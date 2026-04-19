import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../controllers/media_details_controller.dart';

class FullScreenPlayerPage extends StatefulWidget {
  final MediaDetailsController controller;

  const FullScreenPlayerPage({required this.controller});

  @override
  State<FullScreenPlayerPage> createState() => _FullScreenPlayerPageState();
}

class _FullScreenPlayerPageState extends State<FullScreenPlayerPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: YoutubePlayer(
                controller: widget.controller.youtubeController!,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.red,
                bottomActions: [
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.replay_10, color: Colors.white, size: 20),
                    onPressed: () {
                      widget.controller.youtubeController!.seekTo(
                        widget.controller.youtubeController!.value.position -
                            const Duration(seconds: 10),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.forward_10, color: Colors.white, size: 20),
                    onPressed: () {
                      widget.controller.youtubeController!.seekTo(
                        widget.controller.youtubeController!.value.position +
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
                    icon: const Icon(Icons.fullscreen_exit, color: Colors.white, size: 20),
                    onPressed: () => Get.back(),
                    tooltip: 'Exit Full Screen',
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Get.back(),
                tooltip: 'Exit Full Screen',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
