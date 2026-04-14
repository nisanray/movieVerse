import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controllers/profile_controller.dart';

class ProfileManagementPage extends GetView<ProfileController> {
  const ProfileManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: controller.user?.displayName);
    final TextEditingController bioController =
        TextEditingController(text: controller.user?.bio);

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
                    Color(0xFF1A1A2E),
                    Color(0xFF16213E),
                    Color(0xFF0F3460),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Top App Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: _buildGlassIcon(Icons.close_rounded),
                        ),
                        Text(
                          'EDIT PROFILE',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => controller.toggleEditMode(),
                          child: Obx(() => _buildGlassIcon(
                            controller.isEditMode.value 
                              ? Icons.edit_off_rounded 
                              : Icons.edit_rounded,
                            color: controller.isEditMode.value ? Colors.red : Colors.white,
                          )),
                        ),
                      ],
                    ),
                  ),
                ),

                // Interactive Avatar
                SliverToBoxAdapter(
                  child: Center(
                    child: Stack(
                      children: [
                        Obx(() => _buildAvatar(controller.user?.photoUrl)),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => controller.pickAndUploadImage(),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
                  ),
                ),

                // Form Fields
                SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 32),
                      Obx(() => _buildTextField(
                        label: 'DISPLAY NAME',
                        controller: nameController,
                        hint: 'How should we call you?',
                        icon: Icons.person_outline_rounded,
                        enabled: controller.isEditMode.value,
                      )),
                      const SizedBox(height: 24),
                      Obx(() => _buildTextField(
                        label: 'BIO',
                        controller: bioController,
                        hint: 'Tell us about your movie taste...',
                        icon: Icons.history_edu_rounded,
                        maxLines: 4,
                        enabled: controller.isEditMode.value,
                      )),
                      const SizedBox(height: 48),
                      
                      // Save Button
                      Obx(() => controller.isEditMode.value 
                        ? _buildSaveButton(
                            onPressed: () async {
                              if (nameController.text != controller.user?.displayName) {
                                  await controller.updateDisplayName(nameController.text);
                              }
                              if (bioController.text != controller.user?.bio) {
                                  await controller.updateBio(bioController.text);
                              }
                              controller.toggleEditMode(); // Exit edit mode after save
                            },
                            isLoading: controller.isLoading.value,
                          )
                        : const SizedBox.shrink()
                      ),
                      const SizedBox(height: 40),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          
          // Loading Overlay
          Obx(() => controller.isLoading.value 
            ? Container(
                color: Colors.black45,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.red),
                ),
              )
            : const SizedBox.shrink()
          ),
        ],
      ),
    );
  }

  Widget _buildGlassIcon(IconData icon, {Color color = Colors.white}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildAvatar(String? url) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.red.withOpacity(0.5), width: 2),
      ),
      child: CircleAvatar(
        radius: 60,
        backgroundColor: Colors.grey[900],
        backgroundImage: url != null ? NetworkImage(url) : null,
        child: url == null 
          ? const Icon(Icons.person, size: 60, color: Colors.white24) 
          : null,
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.red,
                letterSpacing: 1.5,
              ),
            ),
            if (!enabled)
              const Icon(Icons.lock_outline_rounded, color: Colors.white24, size: 14),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: enabled ? Colors.white.withOpacity(0.05) : Colors.black26,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: TextField(
                controller: controller,
                enabled: enabled,
                maxLines: maxLines,
                style: GoogleFonts.poppins(
                  color: enabled ? Colors.white : Colors.white38, 
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
                  prefixIcon: Icon(icon, color: Colors.white38, size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(20),
                ),
              ),
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 200.ms, duration: 500.ms).moveY(begin: 10, end: 0);
  }

  Widget _buildSaveButton({required VoidCallback onPressed, required bool isLoading}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          shadowColor: Colors.red.withOpacity(0.4),
        ),
        child: Text(
          'SAVE CHANGES',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 1,
          ),
        ),
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0);
  }
}
