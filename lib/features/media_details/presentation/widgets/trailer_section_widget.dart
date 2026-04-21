import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../controllers/media_details_controller.dart';
import '../widgets/related_trailers_widget.dart';
import '../widgets/full_screen_player_page.dart';

class TrailerSectionWidget extends StatelessWidget {
  final MediaDetailsController controller;

  const TrailerSectionWidget({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isTrailerReady.value || controller.youtubeController == null) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.allVideos.length > 1 ? 'Videos' : 'Trailer',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              if (controller.allVideos.length > 1)
                Obx(() => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.red.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '${controller.currentVideoIndex.value + 1} / ${controller.allVideos.length}',
                        style: GoogleFonts.poppins(
                          color: Colors.redAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: YoutubePlayer(
              controller: controller.youtubeController!,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.red,
              bottomActions: [
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(
                    Icons.replay_10,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () {
                    controller.youtubeController!.seekTo(
                      controller.youtubeController!.value.position -
                          const Duration(seconds: 10),
                    );
                  },
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(
                    Icons.forward_10,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () {
                    controller.youtubeController!.seekTo(
                      controller.youtubeController!.value.position +
                          const Duration(seconds: 10),
                    );
                  },
                ),
                const SizedBox(width: 8),
                ProgressBar(
                  isExpanded: true,
                  colors: ProgressBarColors(
                    playedColor: Colors.red,
                    handleColor: Colors.red,
                  ),
                ),
                const SizedBox(width: 8),
                RemainingDuration(),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(
                    Icons.fullscreen,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () =>
                      Get.to(() => FullScreenPlayerPage(controller: controller)),
                  tooltip: 'Full Screen',
                ),
              ],
            ),
          ),
          if (controller.allVideos.length > 1) ...[
            const SizedBox(height: 16),
            RelatedTrailersWidget(controller: controller),
          ],
        ],
      );
    });
  }
}
