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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Trailer',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox.shrink(),
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
  }
}
