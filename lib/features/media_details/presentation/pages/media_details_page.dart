import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../../core/api/api_client.dart';
import '../../../media_discovery/presentation/widgets/media_card.dart';
import '../../../watchlist/presentation/controllers/watchlist_controller.dart';
import '../../data/datasources/media_details_remote_data_source.dart';
import '../../data/repositories/media_details_repository_impl.dart';
import '../../domain/entities/media_details_entities.dart';
import '../../domain/repositories/media_details_repository.dart';
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
        _buildSliverAppBar(details),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleSection(details),
                const SizedBox(height: 24),
                _buildInfoChips(details),
                const SizedBox(height: 16),
                _buildRatingSection(details),
                const SizedBox(height: 16),
                _buildOverview(details),
                const SizedBox(height: 32),
                _buildCastList(details),
                const SizedBox(height: 32),
                _buildTrailerSection(controller),
                const SizedBox(height: 32),
                _buildSimilarSection(controller),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(MediaDetails details) {
    return SliverAppBar(
      expandedHeight: 400,
      backgroundColor: Colors.black,
      pinned: true,
      actions: [
        GetX<WatchlistController>(
          builder: (watchlistController) {
            final isInWatchlist = watchlistController.isInWatchlist(details.id);
            return IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isInWatchlist
                      ? Icons.bookmark_added_rounded
                      : Icons.bookmark_add_outlined,
                  color: isInWatchlist ? Colors.red : Colors.white,
                ),
              ),
              onPressed: () =>
                  watchlistController.toggleWatchlist(details.toMedia()),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: details.fullBackdropPath,
              fit: BoxFit.cover,
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black, Colors.transparent],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSection(MediaDetails details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Content Type Indicator
        _buildContentTypeIndicator(details),
        const SizedBox(height: 12),
        if (details.tagline != null && details.tagline!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              details.tagline!.toUpperCase(),
              style: const TextStyle(
                color: Colors.red,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        Text(
          details.title,
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // TMDB Rating
            const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
            const SizedBox(width: 4),
            Text(
              details.voteAverage.toStringAsFixed(1),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 16),
            const Text('•', style: TextStyle(color: Colors.white24)),
            const SizedBox(width: 16),
            // Release Year
            Text(
              details.releaseDate.split('-').first,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(width: 16),
            const Text('•', style: TextStyle(color: Colors.white24)),
            const SizedBox(width: 16),
            _buildStatusChip(details.status ?? ''),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    if (status.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status,
        style: const TextStyle(color: Colors.white70, fontSize: 10),
      ),
    );
  }

  Widget _buildInfoChips(MediaDetails details) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          if (details.isMovie)
            _buildChip('${details.runtime} min')
          else ...[
            _buildChip('${details.numberOfSeasons} Seasons'),
            _buildChip('${details.numberOfEpisodes} Episodes'),
          ],
          ...details.genres.map((g) => _buildChip(g)),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  Widget _buildOverview(MediaDetails details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          details.overview,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildCastList(MediaDetails details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cast',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: details.cast.length,
            itemBuilder: (context, index) {
              final actor = details.cast[index];
              return Container(
                margin: const EdgeInsets.only(right: 16),
                width: 70,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: CachedNetworkImageProvider(
                        actor.profileUrl,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      actor.name,
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTrailerSection(MediaDetailsController controller) {
    return Obx(() {
      if (!controller.isTrailerReady.value ||
          controller.youtubeController == null) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trailer',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: YoutubePlayer(
              controller: controller.youtubeController!,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.red,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSimilarSection(MediaDetailsController controller) {
    return Obx(() {
      if (controller.similarMedia.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Similar Content',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.similarMedia.length,
              itemBuilder: (context, index) {
                final media = controller.similarMedia[index];
                return MediaCard(media: media);
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildContentTypeIndicator(MediaDetails details) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: details.isMovie ? Colors.red : Colors.blue,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: (details.isMovie ? Colors.red : Colors.blue).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        details.isMovie ? 'MOVIE' : 'TV SHOW',
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildRatingSection(MediaDetails details) {
    final ratingController = _findRatingController();
    if (ratingController == null) return const SizedBox.shrink();

    return Obx(() => StarRatingWidget(
          rating: ratingController.currentRating.value,
          isLoading: ratingController.isLoading.value,
          onRatingChanged: (newRating) {
            ratingController.submitRating(
              rating: newRating,
              genreIds: details.genreIds,
            );
          },
        ));
  }
}
