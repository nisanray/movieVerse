import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/core/constants/app_assets.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(AppAssets.logo, height: 120, fit: BoxFit.contain),
        const SizedBox(height: 16),
        Text(
          'MOVIE VERSE',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
        Text(
          'Your Cinematic Universe',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.white70,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}
