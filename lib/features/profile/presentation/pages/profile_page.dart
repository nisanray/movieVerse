import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../controllers/profile_controller.dart';
import '../widgets/glass_icon_widget.dart';
import '../widgets/avatar_widget.dart';
import '../widgets/section_title_widget.dart';
import '../widgets/glass_tile_widget.dart';
import '../widgets/logout_button_widget.dart';

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
                        GlassIconWidget(
                          icon: Icons.arrow_back_ios_new_rounded,
                          onTap: () => Get.back(),
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
                        const GlassIconWidget(icon: Icons.settings_outlined),
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
                        Stack(
                          children: [
                            AvatarWidget(controller: controller),
                            if (controller.user != null)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () =>
                                      Get.toNamed(AppRoutes.profileManagement),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.edit_rounded,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Obx(
                          () => Text(
                            controller.user?.displayName ?? 'Movie Guest',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Obx(
                          () => Text(
                            controller.user?.email ??
                                'Join the community to sync data',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white60,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Obx(
                          () => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              controller.user?.bio ??
                                  'Sign in to unlock personalized features and save your progress.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.white70,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Settings Sections
                SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SectionTitleWidget(title: 'COLLECTIONS'),
                      GlassTileWidget(
                        icon: Icons.bookmark_outline_rounded,
                        title: 'Watch Later',
                        onTap: () => Get.toNamed(AppRoutes.watchLater),
                      ),
                      GlassTileWidget(
                        icon: Icons.visibility_outlined,
                        title: 'Watched',
                        onTap: () => Get.toNamed(AppRoutes.watchLater), // Both point to Library with tabs
                      ),
                      GlassTileWidget(
                        icon: Icons.star_outline_rounded,
                        title: 'My Ratings',
                        onTap: () => Get.toNamed(AppRoutes.myRatings),
                      ),
                      const SizedBox(height: 32),
                      const SectionTitleWidget(title: 'ACCOUNT'),
                      GlassTileWidget(
                        icon: Icons.person_outline,
                        title: 'Personal Information',
                        onTap: () => Get.toNamed(AppRoutes.profileManagement),
                      ),
                      const GlassTileWidget(
                        icon: Icons.notifications_none_rounded,
                        title: 'Notifications',
                      ),
                      const GlassTileWidget(
                        icon: Icons.security_rounded,
                        title: 'Security & Privacy',
                      ),
                      const SizedBox(height: 32),
                      const SectionTitleWidget(title: 'PREFERENCES'),
                      const GlassTileWidget(
                        icon: Icons.palette_outlined,
                        title: 'Dynamic Theming',
                        trailing: 'ON',
                      ),
                      const GlassTileWidget(
                        icon: Icons.language_rounded,
                        title: 'Language',
                        trailing: 'English',
                      ),
                      const GlassTileWidget(
                        icon: Icons.download_done_rounded,
                        title: 'Downloads',
                      ),
                      const SizedBox(height: 48),
                      LogoutButtonWidget(controller: controller),
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
}
