import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../domain/entities/media.dart';

class MediaCard extends StatelessWidget {
  final Media media;

  const MediaCard({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
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
            ],
          ),
        ),
      ),
    );
  }
}
