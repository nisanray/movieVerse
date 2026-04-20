import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/domain/entities/media.dart';
import '../../../watched/presentation/controllers/watched_controller.dart';
import '../../../recommendations/presentation/controllers/recommendations_controller.dart';

class MediaCard extends StatelessWidget {
  final Media media;

  const MediaCard({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    final watchedController = Get.find<WatchedController>();

    return GestureDetector(
      onTap: () {
        final args = {'id': media.id, 'type': media.isMovie ? 'movie' : 'tv'};

        if (kDebugMode) {
          debugPrint(
            'MediaCard tap -> id=${media.id}, isMovie=${media.isMovie}, currentRoute=${Get.currentRoute}, args=$args',
          );
        }

        // When already on the details route, replace the page instead of stacking
        if (Get.currentRoute == AppRoutes.mediaDetails) {
          if (kDebugMode) {
            debugPrint(
              'MediaCard navigation: using Get.offNamed to mediaDetails',
            );
          }
          Get.offNamed(
            AppRoutes.mediaDetails,
            arguments: args,
            preventDuplicates: false,
          );
        } else {
          if (kDebugMode) {
            debugPrint(
              'MediaCard navigation: using Get.toNamed to mediaDetails',
            );
          }
          Get.toNamed(
            AppRoutes.mediaDetails,
            arguments: args,
            preventDuplicates: false,
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: media.fullPosterPath,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[900],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[900],
                  child: const Icon(Icons.error, color: Colors.white),
                ),
              ),
              // Gradient Overlay
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Title, Tag & Rating
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: media.isMovie
                            ? Colors.red.withOpacity(0.8)
                            : Colors.blue.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        media.isMovie ? 'MOVIE' : 'TV SHOW',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      media.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          media.voteAverage.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Personal Match % Badge
              // Only show in discovery/recommendations, not in library/ratings tabs
              if (Get.isRegistered<RecommendationsController>() &&
                  ![
                    '/my-library',
                    '/watch-later',
                    '/watched',
                    '/my-ratings',
                  ].contains(Get.currentRoute))
                Positioned(
                  top: 8,
                  right: 8,
                  child: GetBuilder<RecommendationsController>(
                    builder: (recController) {
                      final match = recController.getMatchPercentage(media);
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.greenAccent.withOpacity(0.5),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.greenAccent.withOpacity(0.2),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Text(
                          '$match% Match',
                          style: GoogleFonts.poppins(
                            color: Colors.greenAccent,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ).animate().fadeIn().scale(delay: 400.ms);
                    },
                  ),
                ),

              // Watched Badge (Top Left)
              Obx(() {
                final isWatched = watchedController.isWatched(media.id);
                if (!isWatched) return const SizedBox.shrink();

                return Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.greenAccent.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.greenAccent,
                      size: 12,
                    ),
                  ).animate().fadeIn().scale(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

