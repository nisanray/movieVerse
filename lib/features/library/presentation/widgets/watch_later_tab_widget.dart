import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../watch_later/presentation/controllers/watch_later_controller.dart';
import '../../../media_discovery/presentation/widgets/media_card.dart';
import 'empty_state_widget.dart';

class WatchLaterTabWidget extends StatelessWidget {
  final WatchLaterController controller;

  const WatchLaterTabWidget({required this.controller});

  @override
  Widget build(BuildContext context) {
    return controller.obx(
      (watchLaterList) => GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.68,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: watchLaterList!.length,
        itemBuilder: (context, index) {
          return MediaCard(media: watchLaterList[index])
              .animate(delay: (index * 50).ms)
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.1, end: 0);
        },
      ),
      onLoading: const Center(
        child: CircularProgressIndicator(color: Colors.red),
      ),
      onEmpty: const EmptyStateWidget(
        icon: Icons.bookmark_border_rounded,
        title: 'Your Watch Later is Empty',
        message: 'Start adding movies and shows to watch them later!',
      ),
    );
  }
}
