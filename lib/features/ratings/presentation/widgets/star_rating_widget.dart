import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StarRatingWidget extends StatelessWidget {
  final double rating;
  final Function(double) onRatingChanged;
  final bool isLoading;

  const StarRatingWidget({
    super.key,
    required this.rating,
    required this.onRatingChanged,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Side: Labeling & Stars
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Row: Title + Inline Hint
                Row(
                  children: [
                    Text(
                      'WHAT DO YOU THINK?',
                      style: GoogleFonts.poppins(
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        color: Colors.white38,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '•',
                      style: TextStyle(color: Colors.white12, fontSize: 8),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Tap or glide to rate',
                        style: GoogleFonts.poppins(
                          fontSize: 8,
                          color: Colors.white24,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Stars
                GestureDetector(
                  onHorizontalDragUpdate: (details) =>
                      _handleTouch(details.localPosition.dx),
                  onTapDown: (details) =>
                      _handleTouch(details.localPosition.dx),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (index) {
                        return SizedBox(width: 28, child: _buildStar(index));
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Right Side: Score Display (Small "/ 5.0" on the side)
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              if (rating > 0) ...[
                Text(
                  rating.toStringAsFixed(1),
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '/ 5.0',
                  style: GoogleFonts.poppins(
                    fontSize: 10, // Restored to previous small size
                    color: Colors.white24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              if (isLoading) ...[
                const SizedBox(width: 12),
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.amber,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStar(int index) {
    IconData iconData;
    if (rating >= index + 1) {
      iconData = Icons.star_rounded;
    } else if (rating >= index + 0.5) {
      iconData = Icons.star_half_rounded;
    } else {
      iconData = Icons.star_outline_rounded;
    }

    return Icon(
      iconData,
      color: rating >= index + 0.5 ? Colors.amber : Colors.white12,
      size: 20,
    );
  }

  void _handleTouch(double dx) {
    if (isLoading) return;
    double newRating = (dx / 28).clamp(0.0, 5.0);
    newRating = (newRating * 2).round() / 2;
    if (newRating == 0.0 && dx > 0) newRating = 0.5;

    if (newRating != rating) {
      onRatingChanged(newRating);
    }
  }
}
