import 'dart:ui';
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

            // Determine if we should show discovery sections or a results grid
            final bool isSearching = controller.searchQuery.value.isNotEmpty;
            final bool isFilteringByGenre = controller.selectedGenre.value.id != 0;

            return CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 180)), // Space for professional header
                
                if (isSearching || isFilteringByGenre)
                  // Results Grid (Search or Genre Filter)
                  _buildSearchResultsGrid()
                else ...[
                  // Discovery View (Default)
                  SliverToBoxAdapter(
                    child: _buildHeroSection(),
                  ),
                  SliverToBoxAdapter(
                    child: _buildMediaSection(
                      title: 'Trending Now',
                      items: controller.trendingMovies,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _buildMediaSection(
                      title: 'Popular on Movie Verse',
                      items: controller.popularMovies,
                    ),
                  ),
                ],

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
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: EdgeInsets.only(
              top: Get.statusBarHeight + 10,
              left: 20,
              right: 20,
              bottom: 16,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              border: Border(
                bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Row: Brand & Search
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: controller.searchController,
                          focusNode: controller.searchFocusNode,
                          onChanged: (value) => controller.searchQuery.value = value,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Search Movie Verse...',
                            hintStyle: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14),
                            prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.6), size: 20),
                            suffixIcon: controller.searchQuery.value.isNotEmpty 
                              ? IconButton(
                                  icon: const Icon(Icons.clear, color: Colors.white70, size: 18),
                                  onPressed: () {
                                    controller.searchController.clear();
                                    controller.searchQuery.value = '';
                                  },
                                )
                              : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Professional Filter Icon
                    Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.tune_rounded, color: Colors.white70, size: 22),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Secondary Row: Segmented Toggle
                Obx(() => Row(
                  children: [
                    _buildSegmentButton('movie', 'Movies'),
                    const SizedBox(width: 16),
                    _buildSegmentButton('tv', 'TV Shows'),
                  ],
                )),
                const SizedBox(height: 16),

                // Tertiary Row: Genre Chips
                _buildGenreList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentButton(String type, String label) {
    final bool isSelected = controller.selectedMediaType.value == type;
    return GestureDetector(
      onTap: () => controller.toggleMediaType(type),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.4),
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 3,
            width: isSelected ? 20 : 0,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenreList() {
    return SizedBox(
      height: 32,
      child: Obx(() => ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.genres.length,
        itemBuilder: (context, index) {
          final genre = controller.genres[index];
          final isSelected = controller.selectedGenre.value.id == genre.id;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => controller.selectGenre(genre),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.white.withOpacity(0.1),
                  ),
                ),
                child: Center(
                  child: Text(
                    genre.name,
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.white70,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      )),
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
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return MovieCard(media: controller.state![index]);
              },
              childCount: controller.state!.length,
            ),
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
