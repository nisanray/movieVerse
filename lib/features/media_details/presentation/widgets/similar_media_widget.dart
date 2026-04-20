import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/media_details_controller.dart';
import '../../../media_discovery/presentation/widgets/media_card.dart';

class SimilarMediaWidget extends StatelessWidget {
  final MediaDetailsController controller;

  const SimilarMediaWidget({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.similarMedia.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Similar Content',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 0),
              itemCount: controller.similarMedia.length,
              itemBuilder: (context, index) {
                final media = controller.similarMedia[index];
                return SizedBox(
                  width: 150,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: MediaCard(media: media),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
