import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controllers/actor_discovery_controller.dart';
import '../../../media_discovery/presentation/widgets/media_card.dart';

class ActorDiscoveryPage extends GetView<ActorDiscoveryController> {
  const ActorDiscoveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Gradient (Matched to Library screen)
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

          // Main Scroll Content
          controller.obx(
            (mediaList) => CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Top Spacer for Floating Header
                SliverToBoxAdapter(
                  child: SizedBox(height: MediaQuery.of(context).padding.top + 100),
                ),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.64,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return MediaCard(media: mediaList![index])
                            .animate(delay: (index * 40).ms)
                            .fadeIn(duration: 400.ms)
                            .scale(
                              begin: const Offset(0.95, 0.95),
                              end: const Offset(1, 1),
                            )
                            .slideY(begin: 0.1, end: 0);
                      },
                      childCount: mediaList!.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
            onLoading: const Center(
              child: CircularProgressIndicator(color: Colors.red),
            ),
            onEmpty: _buildEmptyState(),
            onError: (error) => _buildErrorState(error!),
          ),

          // Floating Header (For-You Style)
          _buildFloatingHeader(context),
        ],
      ),
    );
  }

  Widget _buildFloatingHeader(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: EdgeInsets.only(
              top: topPadding + 16, // Moved down as requested
              left: 20,
              right: 20,
              bottom: 16,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(80),
              border: Border(
                bottom: BorderSide(color: Colors.white.withAlpha(26)),
              ),
            ),
            child: Row(
              children: [
                // Actor Information (Floating Text)
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DISCOVERY',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFE50914),
                          letterSpacing: 2.5,
                        ),
                      ).animate().fadeIn().slideX(begin: -0.2),
                      const SizedBox(height: 4),
                      Obx(
                        () => Text(
                          controller.actorName.value,
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 22, // Balanced for floating bar
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.1,
                          ),
                        ),
                      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Actor Picture (Far Right)
                Obx(() {
                  if (controller.profileUrl.value.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(26),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withAlpha(32),
                        width: 1,
                      ),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          controller.profileUrl.value,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ).animate().fadeIn(delay: 400.ms).scale(
                        begin: const Offset(0.8, 0.8),
                        curve: Curves.easeOutBack,
                      );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.movie_filter_outlined,
            size: 64,
            color: Colors.white38,
          ),
          SizedBox(height: 16),
          Text(
            'No media found for this actor',
            style: TextStyle(color: Colors.white60, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            error,
            style: GoogleFonts.poppins(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
