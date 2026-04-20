import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../watched/presentation/controllers/watched_controller.dart';
import '../../../media_discovery/presentation/widgets/media_card.dart';
import 'empty_state_widget.dart';

class WatchedTabWidget extends StatelessWidget {
  final WatchedController controller;

  const WatchedTabWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return controller.obx(
      (watchedList) => GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.68,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: watchedList!.length,
        itemBuilder: (context, index) {
          return MediaCard(media: watchedList[index])
              .animate(delay: (index * 50).ms)
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.1, end: 0);
        },
      ),
      onLoading: const Center(
        child: CircularProgressIndicator(color: Colors.red),
      ),
      onEmpty: const EmptyStateWidget(
        icon: Icons.visibility_outlined,
        title: 'No Watched Movies Yet',
        message: 'Rate movies or mark them as watched to build your library!',
      ),
    );
  }
}
