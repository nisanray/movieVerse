import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../core/api/api_client.dart';
import '../../data/datasources/movie_details_remote_data_source.dart';
import '../../data/repositories/movie_details_repository_impl.dart';
import '../../domain/repositories/movie_details_repository.dart';
import '../controllers/movie_details_controller.dart';

class MovieDetailsBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments as Map<String, dynamic>?;
    if (args == null) {
      // Helpful debug log to diagnose navigation issues
      // (e.g., when route is pushed without expected arguments).
      if (kDebugMode) {
        debugPrint(
          'MovieDetailsBinding: Get.arguments is null, skipping controller setup',
        );
      }
      return;
    }

    final int movieId = args['id'];
    final String mediaType = args['type'];
    final String tag = 'movie_$movieId';

    if (kDebugMode) {
      debugPrint(
        'MovieDetailsBinding: setting up for id=$movieId, type=$mediaType, tag=$tag, args=$args',
      );
    }

    // Delete any previous controller with this tag to force a fresh fetch
    if (Get.isRegistered<MovieDetailsController>(tag: tag)) {
      Get.delete<MovieDetailsController>(tag: tag, force: true);
    }

    Get.lazyPut<MovieDetailsRemoteDataSource>(
      () => MovieDetailsRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
      tag: tag,
    );

    Get.lazyPut<MovieDetailsRepository>(
      () => MovieDetailsRepositoryImpl(
        remoteDataSource: Get.find<MovieDetailsRemoteDataSource>(tag: tag),
      ),
      tag: tag,
    );

    Get.put(
      MovieDetailsController(
        Get.find<MovieDetailsRepository>(tag: tag),
        movieId,
        mediaType,
      ),
      tag: tag,
    );

    if (kDebugMode) {
      debugPrint(
        'MovieDetailsBinding: MovieDetailsController put for tag=$tag',
      );
    }
  }
}
