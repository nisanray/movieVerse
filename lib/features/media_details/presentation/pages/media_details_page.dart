import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/api/api_client.dart';
import '../../data/datasources/media_details_remote_data_source.dart';
import '../../data/repositories/media_details_repository_impl.dart';
import '../../domain/entities/media_details_entities.dart';
import '../../domain/repositories/media_details_repository.dart';
import '../widgets/similar_media_widget.dart';
import '../widgets/info_chips_widget.dart';
import '../widgets/overview_widget.dart';
import '../widgets/cast_list_widget.dart';
import '../widgets/trailer_section_widget.dart';
import '../widgets/sliver_app_bar_widget.dart';
import '../widgets/title_section_widget.dart';
import '../../../../features/ratings/presentation/controllers/rating_controller.dart';
import '../../../../features/ratings/presentation/widgets/star_rating_widget.dart';
import '../controllers/media_details_controller.dart';

class MediaDetailsPage extends StatelessWidget {
  const MediaDetailsPage({super.key});

  /// Safely finds the controller using the mediaId from arguments.
  /// If arguments are null (common during route transitions), returns null.
  MediaDetailsController? _findController() {
    final args = Get.arguments as Map<String, dynamic>?;
    if (args == null) {
      if (kDebugMode) {
        debugPrint('MediaDetailsPage._findController: arguments are null');
      }
      return null;
    }
    final int? mediaId = args['id'];
    if (mediaId == null) {
      if (kDebugMode) {
        debugPrint(
          'MediaDetailsPage._findController: mediaId missing in args=$args',
        );
      }
      return null;
    }
    final String tag = 'media_$mediaId';
    if (kDebugMode) {
      debugPrint(
        'MovieDetailsPage._findController: looking for controller with tag=$tag',
      );
    }

    // If the controller is already registered with this tag, just return it.
    if (Get.isRegistered<MediaDetailsController>(tag: tag)) {
      if (kDebugMode) {
        debugPrint(
          'MediaDetailsPage._findController: found existing controller for tag=$tag',
        );
      }
      return Get.find<MediaDetailsController>(tag: tag);
    }

    // If not registered (for example, if the binding didn't run as expected),
    // create the required dependencies and controller on the fly.
    try {
      if (kDebugMode) {
        debugPrint(
          'MovieDetailsPage._findController: controller not found, creating on the fly for tag=$tag',
        );
      }

      final ApiClient apiClient = Get.find<ApiClient>();

      final MediaDetailsRemoteDataSource remoteDataSource =
          MediaDetailsRemoteDataSourceImpl(apiClient: apiClient);

      final MediaDetailsRepository repository = MediaDetailsRepositoryImpl(
        remoteDataSource: remoteDataSource,
      );

      final controller = MediaDetailsController(
        repository,
        mediaId,
        args['type'] as String,
      );

      Get.put<MediaDetailsController>(controller, tag: tag);

      if (kDebugMode) {
        debugPrint(
          'MovieDetailsPage._findController: controller created and registered for tag=$tag',
        );
      }

      return controller;
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
          'MovieDetailsPage._findController: failed to create controller for tag=$tag, error=$e',
        );
      }
      return null;
    }
  }

  /// Safely finds the RatingController using the mediaId from arguments.
  RatingController? _findRatingController() {
    final args = Get.arguments as Map<String, dynamic>?;
    if (args == null) return null;
    final int? mediaId = args['id'];
    if (mediaId == null) return null;
    final String tag = 'media_$mediaId';

    if (Get.isRegistered<RatingController>(tag: tag)) {
      return Get.find<RatingController>(tag: tag);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final controller = _findController();

    // If controller is not found (e.g. during a transition where arguments are null),
    // we return a beautiful empty scaffold instead of crashing.
    if (controller == null) {
      return const Scaffold(backgroundColor: Colors.black);
    }

    return Scaffold(
      // Use a key based on mediaId to force Flutter to rebuild this widget
      // when the mediaId changes (important for Get.offNamed on same route).
      key: ValueKey<int>(controller.mediaId),
      backgroundColor: Colors.black,
      body: controller.obx(
        (details) => details != null
            ? _buildContent(details, controller)
            : const SizedBox.shrink(),
        onLoading: const Center(
          child: CircularProgressIndicator(color: Colors.red),
        ),
        onError: (error) => Center(
          child: Text(
            'Error: $error',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    MediaDetails details,
    MediaDetailsController controller,
  ) {
    return CustomScrollView(
      slivers: [
        SliverAppBarWidget(details: details),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleSectionWidget(details: details),
                const SizedBox(height: 24),
                InfoChipsWidget(details: details),
                const SizedBox(height: 16),
                _buildRatingSection(details),
                const SizedBox(height: 16),
                OverviewWidget(details: details),
                const SizedBox(height: 32),
                CastListWidget(details: details),
                const SizedBox(height: 32),
                TrailerSectionWidget(controller: controller),
                const SizedBox(height: 24),
                SimilarMediaWidget(controller: controller),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingSection(MediaDetails details) {
    final ratingController = _findRatingController();
    if (ratingController == null) return const SizedBox.shrink();

    return Obx(
      () => StarRatingWidget(
        rating: ratingController.currentRating.value,
        isLoading: ratingController.isLoading.value,
        onRatingChanged: (newRating) {
          ratingController.submitRating(
            rating: newRating,
            genreIds: details.genreIds,
            title: details.title,
            posterPath: details.posterPath,
          );
        },
      ),
    );
  }
}
