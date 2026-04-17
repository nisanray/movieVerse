import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controllers/watchlist_controller.dart';
import '../../../media_discovery/presentation/widgets/media_card.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../../core/navigation/app_routes.dart';

class WatchlistPage extends GetView<WatchlistController> {
  const WatchlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'My Watchlist',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),
        ),
      ),
      body: controller.obx(
        (watchlist) => GridView.builder(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 70,
            left: 16,
            right: 16,
            bottom: 24,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: watchlist!.length,
          itemBuilder: (context, index) {
            return MediaCard(media: watchlist[index])
                .animate(delay: (index * 100).ms)
                .fadeIn(duration: 500.ms)
                .slideY(begin: 0.2, end: 0, curve: Curves.easeOut);
          },
        ),
        onLoading: const Center(child: CircularProgressIndicator(color: Colors.red)),
        onEmpty: _buildEmptyState(),
        onError: (error) => Center(child: Text('Error: $error', style: const TextStyle(color: Colors.white))),
      ),
    );
  }

  Widget _buildEmptyState() {
    final authController = Get.find<AuthController>();
    final isGuest = authController.user.value == null;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isGuest ? Icons.cloud_off_rounded : Icons.bookmark_border_rounded,
              size: 80,
              color: Colors.white.withOpacity(0.1),
            ),
            const SizedBox(height: 24),
            Text(
              isGuest ? 'Sync Required' : 'Your Watchlist is Empty',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isGuest
                  ? 'Sign in to sync your watchlist across devices and never lose your favorites.'
                  : 'Start adding movies and shows to keep track of them!',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.white60, fontSize: 14),
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
