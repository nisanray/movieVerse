import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/media_details_entities.dart';
import '../../../watch_later/presentation/controllers/watch_later_controller.dart';

class WatchLaterButtonWidget extends StatelessWidget {
  final MediaDetails details;

  const WatchLaterButtonWidget({required this.details, super.key});

  @override
  Widget build(BuildContext context) {
    final WatchLaterController watchLaterController =
        Get.find<WatchLaterController>();

    return Obx(() {
      final isInWatchLater = watchLaterController.isInWatchLater(details.id);

      return GestureDetector(
        onTap: () {
          watchLaterController.toggleWatchLater(details.toMedia());
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isInWatchLater
                  ? [Colors.red.withOpacity(0.8), Colors.red]
                  : [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.05),
                    ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isInWatchLater ? Colors.red : Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isInWatchLater ? Icons.bookmark : Icons.bookmark_outline_rounded,
                color: isInWatchLater ? Colors.white : Colors.white70,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                isInWatchLater ? 'In Watch Later' : 'Add to Watch Later',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isInWatchLater ? Colors.white : Colors.white70,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
