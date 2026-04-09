import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/navigation/app_routes.dart';
import '../controllers/movie_discovery_controller.dart';
import '../widgets/movie_card.dart';

class MovieDiscoveryPage extends GetView<MovieDiscoveryController> {
  const MovieDiscoveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.red));
        }

        return CustomScrollView(
          slivers: [
            // Hero Backdrop section
            SliverToBoxAdapter(
              child: _buildHeroSection(),
            ),

            // Trending Now
            SliverToBoxAdapter(
              child: _buildMovieSection(
                title: 'Trending Now',
                movies: controller.trendingMovies,
              ),
            ),

            // Popular Movies
            SliverToBoxAdapter(
              child: _buildMovieSection(
                title: 'Popular on Movie Verse',
                movies: controller.popularMovies,
              ),
            ),

            // Bottom padding
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        );
      }),
    );
  }

  Widget _buildHeroSection() {
    if (controller.nowPlayingMovies.isEmpty) return const SizedBox.shrink();
    final featuredMovie = controller.nowPlayingMovies.first;

    return Container(
      height: Get.height * 0.6,
      width: double.infinity,
      child: Stack(
        children: [
          // Background Backdrop
          CachedNetworkImage(
            imageUrl: featuredMovie.fullBackdropPath,
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
                Text(
                  featuredMovie.title,
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
                      featuredMovie.voteAverage.toStringAsFixed(1),
                      style: const TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      featuredMovie.releaseDate.split('-').first,
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
                        arguments: featuredMovie.id,
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
                        arguments: featuredMovie.id,
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

  Widget _buildMovieSection({required String title, required List movies}) {
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
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return MovieCard(movie: movies[index]);
            },
          ),
        ),
      ],
    );
  }
}
