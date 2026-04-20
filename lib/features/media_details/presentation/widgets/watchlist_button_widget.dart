import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/media_details_entities.dart';
import '../../../watchlist/presentation/controllers/watchlist_controller.dart';

class WatchlistButtonWidget extends StatelessWidget {
  final MediaDetails details;

  const WatchlistButtonWidget({required this.details, super.key});

  @override
  Widget build(BuildContext context) {
    final WatchlistController watchlistController =
        Get.find<WatchlistController>();

    return Obx(() {
      final isInWatchlist = watchlistController.isInWatchlist(details.id);

      return GestureDetector(
        onTap: () {
          watchlistController.toggleWatchlist(details.toMedia());
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isInWatchlist
                  ? [Colors.red.withOpacity(0.8), Colors.red]
                  : [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.05),
                    ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isInWatchlist ? Colors.red : Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isInWatchlist ? Icons.bookmark : Icons.bookmark_outline_rounded,
                color: isInWatchlist ? Colors.white : Colors.white70,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                isInWatchlist ? 'In Watchlist' : 'Add to Watchlist',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isInWatchlist ? Colors.white : Colors.white70,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
