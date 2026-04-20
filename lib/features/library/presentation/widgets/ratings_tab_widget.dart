import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../ratings/presentation/controllers/my_ratings_controller.dart';
import '../../../media_discovery/presentation/widgets/media_card.dart';
import 'empty_state_widget.dart';

class RatingsTabWidget extends StatelessWidget {
  final MyRatingsController controller;

  const RatingsTabWidget({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.red),
        );
      }

      if (controller.userRatings.isEmpty) {
        return EmptyStateWidget(
          icon: Icons.star_outline_rounded,
          title: 'No Ratings Yet',
          message: 'Rate content to see your personal history here.',
        );
      }

      return GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.68,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: controller.userRatings.length,
        itemBuilder: (context, index) {
          final rating = controller.userRatings[index];
          final media = controller.mapToMedia(rating);
          return Stack(
                children: [
                  MediaCard(media: media),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: Colors.amber.withOpacity(0.4),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 10),
                          const SizedBox(width: 4),
                          Text(
                            rating.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
              .animate(delay: (index * 50).ms)
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.1, end: 0);
        },
      );
    });
  }
}
