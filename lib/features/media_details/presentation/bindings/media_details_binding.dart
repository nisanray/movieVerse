import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../core/api/api_client.dart';
import '../../data/datasources/media_details_remote_data_source.dart';
import '../../data/repositories/media_details_repository_impl.dart';
import '../../domain/repositories/media_details_repository.dart';
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

    if (kDebugMode) {
      debugPrint(
        'MediaDetailsBinding: MediaDetailsController put for tag=$tag',
      );
    }
  }
}
