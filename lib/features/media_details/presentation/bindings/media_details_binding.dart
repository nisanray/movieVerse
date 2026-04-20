import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../core/api/api_client.dart';
import '../../data/datasources/media_details_remote_data_source.dart';
import '../../data/repositories/media_details_repository_impl.dart';
import '../../domain/repositories/media_details_repository.dart';
import '../../../../features/ratings/data/repositories/rating_repository_impl.dart';
import '../../../../features/ratings/domain/repositories/rating_repository.dart';
import '../../../../features/ratings/presentation/controllers/rating_controller.dart';
import '../../../../features/watched/domain/repositories/watched_repository.dart';
import '../../../../features/watched/data/repositories/watched_repository_impl.dart';
import '../../../../features/watched/domain/usecases/add_to_watched_use_case.dart';
import '../../../../features/watch_later/domain/repositories/watch_later_repository.dart';
import '../../../../features/watch_later/data/repositories/watch_later_repository_impl.dart';
import '../controllers/media_details_controller.dart';

class MediaDetailsBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments as Map<String, dynamic>?;
    if (args == null) {
      // Helpful debug log to diagnose navigation issues
      // (e.g., when route is pushed without expected arguments).
      if (kDebugMode) {
        debugPrint(
          'MediaDetailsBinding: Get.arguments is null, skipping controller setup',
        );
      }
      return;
    }

    final int mediaId = args['id'];
    final String mediaType = args['type'];
    final String tag = 'media_$mediaId';

    if (kDebugMode) {
      debugPrint(
        'MediaDetailsBinding: setting up for id=$mediaId, type=$mediaType, tag=$tag, args=$args',
      );
    }

    // Delete any previous controller with this tag to force a fresh fetch
    if (Get.isRegistered<MediaDetailsController>(tag: tag)) {
      Get.delete<MediaDetailsController>(tag: tag, force: true);
    }

    Get.lazyPut<MediaDetailsRemoteDataSource>(
      () => MediaDetailsRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
      tag: tag,
    );

    Get.lazyPut<MediaDetailsRepository>(
      () => MediaDetailsRepositoryImpl(
        remoteDataSource: Get.find<MediaDetailsRemoteDataSource>(tag: tag),
      ),
      tag: tag,
    );

    Get.put(
      MediaDetailsController(
        Get.find<MediaDetailsRepository>(tag: tag),
        mediaId,
        mediaType,
      ),
      tag: tag,
    );

    // Setup Rating Controller
    Get.lazyPut<RatingRepository>(
      () => RatingRepositoryImpl(),
      tag: tag,
    );

    // Ensure repositories are available for use case
    if (!Get.isRegistered<WatchedRepository>()) {
      Get.lazyPut<WatchedRepository>(() => WatchedRepositoryImpl());
    }
    if (!Get.isRegistered<WatchLaterRepository>()) {
      Get.lazyPut<WatchLaterRepository>(() => WatchLaterRepositoryImpl());
    }

    Get.put(
      RatingController(
        Get.find<RatingRepository>(tag: tag),
        mediaId,
        mediaType,
        addToWatchedUseCase: AddToWatchedUseCase(
          watchedRepository: Get.find<WatchedRepository>(),
          watchLaterRepository: Get.find<WatchLaterRepository>(),
        ),
      ),
      tag: tag,
    );

    if (kDebugMode) {
      debugPrint(
        'MediaDetailsBinding: MediaDetailsController put for tag=$tag',
      );
    }
  }
}
