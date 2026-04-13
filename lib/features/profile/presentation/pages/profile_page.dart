import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../controllers/profile_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Aesthetic
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0F0C29),
                    Color(0xFF302B63),
                    Color(0xFF24243E),
                  ],
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Top Custom Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: _buildGlassIcon(Icons.arrow_back_ios_new_rounded),
                        ),
                        Text(
                          'MY PROFILE',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                        _buildGlassIcon(Icons.settings_outlined),
                      ],
                    ),
                  ),
                ),

                // Profile Info
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        _buildAvatar(),
                        const SizedBox(height: 20),
                        Obx(() => Text(
                          controller.user?.displayName ?? 'Movie Enthusiast',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )),
                        Obx(() => Text(
                          controller.user?.email ?? 'explore@movieverse.com',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white60,
                          ),
                        )),
                      ],
                    ),
                  ),
                ),

                // Settings Sections
                SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildSectionTitle('COLLECTIONS'),
                      GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.watchlist),
                        child: _buildGlassTile(Icons.bookmark_outline_rounded, 'My Watchlist'),
                      ),
                      
                      const SizedBox(height: 32),
                      _buildSectionTitle('ACCOUNT'),
                      _buildGlassTile(Icons.person_outline, 'Personal Information'),
                      _buildGlassTile(Icons.notifications_none_rounded, 'Notifications'),
                      _buildGlassTile(Icons.security_rounded, 'Security & Privacy'),
                      
                      const SizedBox(height: 32),
                      _buildSectionTitle('PREFERENCES'),
                      _buildGlassTile(Icons.palette_outlined, 'Dynamic Theming', trailing: 'ON'),
                      _buildGlassTile(Icons.language_rounded, 'Language', trailing: 'English'),
                      _buildGlassTile(Icons.download_done_rounded, 'Downloads'),

                      const SizedBox(height: 48),
                      _buildLogoutButton(),
                      const SizedBox(height: 40),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildAvatar() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Colors.red, Colors.orange],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 60,
        backgroundColor: Colors.grey[900],
        backgroundImage: controller.user?.photoUrl != null 
          ? NetworkImage(controller.user!.photoUrl!) 
          : null,
        child: controller.user?.photoUrl == null 
          ? const Icon(Icons.person, size: 60, color: Colors.white24) 
          : null,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.red,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildGlassTile(IconData icon, String title, {String? trailing}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white70, size: 22),
        title: Text(
          title,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
        ),
        trailing: trailing != null 
          ? Text(trailing, style: const TextStyle(color: Colors.red, fontSize: 12))
          : const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white24, size: 14),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => controller.logout(),
        icon: const Icon(Icons.logout_rounded),
        label: const Text('SIGN OUT'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.05),
          foregroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Colors.red, width: 0.5),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
