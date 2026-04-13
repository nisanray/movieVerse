import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../../core/api/api_client.dart';
import '../../../movie_discovery/presentation/widgets/movie_card.dart';
import '../../../watchlist/presentation/controllers/watchlist_controller.dart';
import '../../data/datasources/movie_details_remote_data_source.dart';
import '../../data/repositories/movie_details_repository_impl.dart';
import '../../domain/entities/movie_details_entities.dart';
import '../../domain/repositories/movie_details_repository.dart';
import '../controllers/movie_details_controller.dart';

class MovieDetailsPage extends StatelessWidget {
  const MovieDetailsPage({super.key});

  /// Safely finds the controller using the movieId from arguments.
  /// If arguments are null (common during route transitions), returns null.
  MovieDetailsController? _findController() {
    final args = Get.arguments as Map<String, dynamic>?;
    if (args == null) {
      if (kDebugMode) {
        debugPrint('MovieDetailsPage._findController: arguments are null');
      }
      return null;
    }
    final int? movieId = args['id'];
    if (movieId == null) {
      if (kDebugMode) {
        debugPrint(
          'MovieDetailsPage._findController: movieId missing in args=$args',
        );
      }
      return null;
    }
    final String tag = 'movie_$movieId';
    if (kDebugMode) {
      debugPrint(
        'MovieDetailsPage._findController: looking for controller with tag=$tag',
      );
    }

    // If the controller is already registered with this tag, just return it.
    if (Get.isRegistered<MovieDetailsController>(tag: tag)) {
      if (kDebugMode) {
        debugPrint(
          'MovieDetailsPage._findController: found existing controller for tag=$tag',
        );
      }
      return Get.find<MovieDetailsController>(tag: tag);
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

      final MovieDetailsRemoteDataSource remoteDataSource =
          MovieDetailsRemoteDataSourceImpl(apiClient: apiClient);

      final MovieDetailsRepository repository = MovieDetailsRepositoryImpl(
        remoteDataSource: remoteDataSource,
      );

      final controller = MovieDetailsController(
        repository,
        movieId,
        args['type'] as String,
      );

      Get.put<MovieDetailsController>(controller, tag: tag);

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

  @override
  Widget build(BuildContext context) {
    final controller = _findController();

    // If controller is not found (e.g. during a transition where arguments are null),
    // we return a beautiful empty scaffold instead of crashing.
    if (controller == null) {
      return const Scaffold(backgroundColor: Colors.black);
    }

    return Scaffold(
      // Use a key based on movieId to force Flutter to rebuild this widget
      // when the movieId changes (important for Get.offNamed on same route).
      key: ValueKey<int>(controller.movieId),
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
    MovieDetails details,
    MovieDetailsController controller,
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
                const SizedBox(height: 24),
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

  Widget _buildSliverAppBar(MovieDetails details) {
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

  Widget _buildTitleSection(MovieDetails details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            const Icon(Icons.star, color: Colors.amber, size: 20),
            const SizedBox(width: 4),
            Text(
              details.voteAverage.toStringAsFixed(1),
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(width: 16),
            Text(
              details.releaseDate.split('-').first,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
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

  Widget _buildInfoChips(MovieDetails details) {
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

  Widget _buildOverview(MovieDetails details) {
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

  Widget _buildCastList(MovieDetails details) {
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

  Widget _buildTrailerSection(MovieDetailsController controller) {
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

  Widget _buildSimilarSection(MovieDetailsController controller) {
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
                return MovieCard(media: media);
              },
            ),
          ),
        ],
      );
    });
  }
}
