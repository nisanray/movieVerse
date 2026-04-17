import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../watchlist/presentation/controllers/watchlist_controller.dart';
import '../../../ratings/presentation/controllers/my_ratings_controller.dart';
import '../../../media_discovery/presentation/widgets/media_card.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../../core/navigation/app_routes.dart';

class MyLibraryPage extends StatelessWidget {
  const MyLibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure both controllers are available
    final watchlistController = Get.find<WatchlistController>();
    final ratingsController = Get.find<MyRatingsController>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Background Gradient (Matched to "For You" page)
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
            NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  _buildSliverAppBar(context),
                ];
              },
              body: TabBarView(
                children: [
                  _buildWatchlistTab(watchlistController),
                  _buildRatingsTab(ratingsController),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 130,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.only(left: 24.0, top: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PERSONAL',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  letterSpacing: 4,
                ),
              ).animate().fadeIn().slideX(begin: -0.2),
              const SizedBox(height: 8),
              Text(
                'My Library',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.1,
                ),
              ).animate().fadeIn(delay: 200.ms),
            ],
          ),
        ),
        centerTitle: false,
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.transparent), // Removed white bar
            ),
          ),
          child: TabBar(
            dividerColor: Colors.transparent, // Remove the white/grey divider line
            indicatorColor: Colors.red,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white38,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            labelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              letterSpacing: 1,
            ),
            tabs: const [
              Tab(text: 'WATCHLIST'),
              Tab(text: 'RATED'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWatchlistTab(WatchlistController controller) {
    return controller.obx(
      (watchlist) => GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.68,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: watchlist!.length,
        itemBuilder: (context, index) {
          return MediaCard(media: watchlist[index])
              .animate(delay: (index * 50).ms)
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.1, end: 0);
        },
      ),
      onLoading: const Center(child: CircularProgressIndicator(color: Colors.red)),
      onEmpty: _buildEmptyState(
        icon: Icons.bookmark_border_rounded,
        title: 'Your Watchlist is Empty',
        message: 'Start adding movies and shows to keep track of them!',
      ),
    );
  }

  Widget _buildRatingsTab(MyRatingsController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator(color: Colors.red));
      }

      if (controller.userRatings.isEmpty) {
        return _buildEmptyState(
          icon: Icons.star_outline_rounded,
          title: 'No Ratings Yet',
          message: 'Rate content to see your personal history here.',
        );
      }

      return GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.68,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: controller.userRatings.length,
        itemBuilder: (context, index) {
          final rating = controller.userRatings[index];
          final media = controller.mapToMedia(rating);
          return Stack(
            children: [
              MediaCard(media: media),
              // Personal Rating Badge
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.amber.withOpacity(0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 10),
                      const SizedBox(width: 4),
                      Text(
                        rating.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ).animate(delay: (index * 50).ms).fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
        },
      );
    });
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    final authController = Get.find<AuthController>();
    final isGuest = authController.user.value == null;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isGuest ? Icons.cloud_off_rounded : icon,
              size: 64,
              color: Colors.white.withOpacity(0.1),
            ),
            const SizedBox(height: 24),
            Text(
              isGuest ? 'Sign In Required' : title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isGuest
                  ? 'Sign in to sync your library across devices and keep your ratings safe.'
                  : message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.white38, fontSize: 13),
            ),
            if (isGuest) ...[
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Get.toNamed(AppRoutes.auth),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('Sign In Now'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
