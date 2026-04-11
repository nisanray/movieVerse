import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/navigation/app_routes.dart';
import '../controllers/movie_discovery_controller.dart';
import '../widgets/movie_card.dart';
import '../../domain/entities/media.dart';

class MovieDiscoveryPage extends GetView<MovieDiscoveryController> {
  const MovieDiscoveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator(color: Colors.red));
            }

            return CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 120)), // Space for top UI
                // Hero Backdrop section
                SliverToBoxAdapter(
                  child: _buildHeroSection(),
                ),

                // Trending Now
                SliverToBoxAdapter(
                  child: _buildMediaSection(
                    title: 'Trending Now',
                    items: controller.trendingMovies,
                  ),
                ),

                // Popular Media
                SliverToBoxAdapter(
                  child: _buildMediaSection(
                    title: 'Popular on Movie Verse',
                    items: controller.popularMovies,
                  ),
                ),

                // Bottom padding
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            );
          }),

          // Top Floating Interface
          _buildTopInterface(),
        ],
      ),
    );
  }

  Widget _buildTopInterface() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(top: Get.statusBarHeight + 10, left: 20, right: 20, bottom: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.black.withOpacity(0.4),
              Colors.transparent,
            ],
          ),
        ),
        child: Column(
          children: [
            // Search Bar
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white24),
              ),
              child: const TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search movies, tv shows...',
                  hintStyle: TextStyle(color: Colors.white54),
                  prefixIcon: Icon(Icons.search, color: Colors.white70),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Media Toggle
            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildToggleButton('movie', 'Movies'),
                const SizedBox(width: 12),
                _buildToggleButton('tv', 'TV Shows'),
              ],
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(String type, String label) {
    final bool isSelected = controller.selectedMediaType.value == type;
    return GestureDetector(
      onTap: () => controller.toggleMediaType(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Colors.red : Colors.white24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    if (controller.nowPlayingMovies.isEmpty) return const SizedBox.shrink();
    final featuredMedia = controller.nowPlayingMovies.first;

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
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: featuredMedia.isMovie ? Colors.red : Colors.blue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    featuredMedia.isMovie ? 'FEATURED MOVIE' : 'FEATURED TV SHOW',
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
                      style: const TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      featuredMedia.releaseDate.split('-').first,
                      style: const TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => Get.toNamed(
                        AppRoutes.movieDetails,
                        arguments: featuredMedia.id,
                      ),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Play'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton.icon(
                      onPressed: () => Get.toNamed(
                        AppRoutes.movieDetails,
                        arguments: featuredMedia.id,
                      ),
                      icon: const Icon(Icons.info_outline, color: Colors.white),
                      label: const Text('More Info', style: TextStyle(color: Colors.white)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaSection({required String title, required List<Media> items}) {
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
              return MovieCard(media: items[index]);
            },
          ),
        ),
      ],
    );
  }
}
