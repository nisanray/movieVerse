import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/navigation/app_routes.dart';
import '../controllers/media_discovery_controller.dart';
import '../widgets/media_card.dart';
import '../widgets/discovery_header.dart';
import '../widgets/filter_drawer.dart';
import '../../domain/entities/media.dart';

class MediaDiscoveryPage extends GetView<MediaDiscoveryController> {
  const MediaDiscoveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      endDrawer: const FilterDrawer(),
      body: Stack(
        children: [
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.red),
              );
            }

            // Determine if we should show discovery sections or a results grid
            final bool isSearching = controller.searchQuery.value.isNotEmpty;
            final bool isFilteringByGenre =
                controller.selectedGenre.value.id != 0;

            return CustomScrollView(
              controller: controller.scrollController,
              slivers: [
                const SliverToBoxAdapter(
                  child: SizedBox(height: 96),
                ), // Space for floating header

                if (isSearching || isFilteringByGenre)
                  // Results Grid (Search or Genre Filter)
                  _buildSearchResultsGrid()
                else ...[
                  // Discovery View (Default)
                  SliverToBoxAdapter(child: _buildHeroSection()),
                  SliverToBoxAdapter(
                    child: _buildMediaSection(
                      title: controller.selectedMediaType.value == 'movie'
                          ? 'Trending Movies'
                          : 'Trending TV Shows',
                      items: controller.trendingMedia,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _buildMediaSection(
                      title: controller.selectedMediaType.value == 'movie'
                          ? 'Popular on Movie Verse'
                          : 'Top Rated Series',
                      items: controller.popularMedia,
                    ),
                  ),
                ],

                // Bottom padding
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            );
          }),

          // Top Floating Interface (Aero-Glass)
          const DiscoveryHeader(),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70), // Avoid bottom nav overlap
        child: FloatingActionButton(
          onPressed: () => Get.toNamed(AppRoutes.aiScout),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE50914), Color(0xFF0F0C29)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 28),
          ),
        ),
      ).animate().scale(delay: const Duration(seconds: 1), duration: const Duration(milliseconds: 500), curve: Curves.elasticOut),
    );
  }

  Widget _buildSearchResultsGrid() {
    return controller.state != null && controller.state!.isNotEmpty
        ? SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                return MediaCard(media: controller.state![index]);
              }, childCount: controller.state!.length),
            ),
          )
        : const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 100),
                child: Text(
                  'No results found',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
            ),
          );
  }

  Widget _buildHeroSection() {
    if (controller.nowPlayingMedia.isEmpty) return const SizedBox.shrink();
    final featuredMedia = controller.nowPlayingMedia.first;

    return Container(
      height: Get.height * 0.6,
      width: double.infinity,
      child: Stack(
        children: [
          // Background Backdrop
          CachedNetworkImage(
            imageUrl: featuredMedia.fullBackdropPath,
            height: Get.height * 0.6,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(color: Colors.black),
          ),

          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black,
                  Colors.black.withOpacity(0.5),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Content
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: featuredMedia.isMovie ? Colors.red : Colors.blue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    featuredMedia.isMovie
                        ? 'FEATURED MOVIE'
                        : 'FEATURED TV SHOW',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  featuredMedia.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      featuredMedia.voteAverage.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      featuredMedia.releaseDate.split('-').first,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => Get.toNamed(
                          AppRoutes.mediaDetails,
                          arguments: {
                            'id': featuredMedia.id,
                            'type': featuredMedia.isMovie ? 'movie' : 'tv',
                          },
                        ),
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Play'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton.icon(
                        onPressed: () => Get.toNamed(
                          AppRoutes.mediaDetails,
                          arguments: {
                            'id': featuredMedia.id,
                            'type': featuredMedia.isMovie ? 'movie' : 'tv',
                          },
                        ),
                        icon: const Icon(
                          Icons.info_outline,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'More Info',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaSection({
    required String title,
    required List<Media> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 240, // Slightly increased to fit the MOVIE/TV tags
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return SizedBox(
                width: 156, // 140 (card) + 16 (spacing)
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: MediaCard(media: items[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
