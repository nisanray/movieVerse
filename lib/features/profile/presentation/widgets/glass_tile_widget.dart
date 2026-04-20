import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GlassTileWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailing;
  final VoidCallback? onTap;

  const GlassTileWidget({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              ? Text(trailing!, style: const TextStyle(color: Colors.red, fontSize: 12))
              : const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white24, size: 14),
        ),
      ),
    );
  }
}
