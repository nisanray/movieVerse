import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../controllers/auth_controller.dart';

class SocialAuthWidget extends StatelessWidget {
  const SocialAuthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: Colors.white.withOpacity(0.1))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'OR CONTINUE WITH',
                style: GoogleFonts.poppins(
                  color: Colors.white38,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            Expanded(child: Divider(color: Colors.white.withOpacity(0.1))),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialButtonWidget(
              icon: FontAwesomeIcons.google,
              color: Colors.white,
              onTap: () => controller.loginWithGoogle(),
            ),
            const SizedBox(width: 20),
            const SocialButtonWidget(
              icon: FontAwesomeIcons.apple,
              color: Colors.white,
              onTap: null,
            ),
            const SizedBox(width: 20),
            const SocialButtonWidget(
              icon: FontAwesomeIcons.facebook,
              color: Color(0xFF1877F2),
              onTap: null,
            ),
          ],
        ),
      ],
    );
  }
}

class SocialButtonWidget extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const SocialButtonWidget({
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        width: 56,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Center(child: FaIcon(icon, color: color, size: 24)),
      ),
    );
  }
}
