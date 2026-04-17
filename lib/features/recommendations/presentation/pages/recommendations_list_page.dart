import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:marquee/marquee.dart';
import '../../../media_discovery/domain/entities/media.dart';
import '../../../media_discovery/presentation/widgets/media_card.dart';

class RecommendationsListPage extends StatelessWidget {
  final String title;
  final List<Media> items;

  const RecommendationsListPage({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Gradient (Matching the Discovery/Recommendations aesthetic)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0F0C29), Color(0xFF1B1B1B), Colors.black],
                ),
              ),
            ),
          ),

          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildAppBar(),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return MediaCard(media: items[index])
                          .animate()
                          .fadeIn(delay: (index * 50).ms)
                          .scale(begin: const Offset(0.9, 0.9));
                    }, childCount: items.length),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 20,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => Get.back(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: title.toUpperCase() == 'PERSONALIZED PICKS'
                  ? Text(
                      title.toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                        height: 1.0,
                      ),
                    )
                  : SizedBox(
                      height: 22,
                      child: Marquee(
                        text: title.toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                          height: 1.0,
                        ),
                        scrollAxis: Axis.horizontal,
                        velocity: 30.0,
                        blankSpace: 40.0,
                        pauseAfterRound: const Duration(seconds: 3),
                      ),
                    ),
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(color: Colors.transparent),
      ),
    );
  }
}
