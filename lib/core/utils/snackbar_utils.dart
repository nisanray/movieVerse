import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// A centralized, premium snackbar utility for consistent
/// user feedback across the MovieVerse app.
class SnackbarUtils {
  // ─── Success ──────────────────────────────────────────────
  static void success({required String title, required String message}) {
    _showSnackbar(
      title: title,
      message: message,
      gradient: const LinearGradient(
        colors: [Color(0xFF1DB954), Color(0xFF17A845)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      icon: Icons.check_circle_rounded,
      borderColor: const Color(0xFF1DB954),
    );
  }

  // ─── Error ────────────────────────────────────────────────
  static void error({required String title, required String message}) {
    _showSnackbar(
      title: title,
      message: message,
      gradient: const LinearGradient(
        colors: [Color(0xFFE53935), Color(0xFFC62828)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      icon: Icons.error_rounded,
      borderColor: const Color(0xFFE53935),
    );
  }

  // ─── Info ─────────────────────────────────────────────────
  static void info({required String title, required String message}) {
    _showSnackbar(
      title: title,
      message: message,
      gradient: const LinearGradient(
        colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      icon: Icons.info_rounded,
      borderColor: const Color(0xFF1E88E5),
    );
  }

  // ─── Warning ──────────────────────────────────────────────
  static void warning({required String title, required String message}) {
    _showSnackbar(
      title: title,
      message: message,
      gradient: const LinearGradient(
        colors: [Color(0xFFF57C00), Color(0xFFE65100)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      icon: Icons.warning_rounded,
      borderColor: const Color(0xFFFF9800),
    );
  }

  // ─── Core renderer ────────────────────────────────────────
  static void _showSnackbar({
    required String title,
    required String message,
    required LinearGradient gradient,
    required IconData icon,
    required Color borderColor,
  }) {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();

    Get.snackbar(
      '',
      '',
      // Hide the title slot — layout is fully custom inside messageText
      titleText: const SizedBox.shrink(),
      messageText: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon badge — centered relative to the whole Row
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          // Title + message stacked vertically
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: GoogleFonts.poppins(
                    color: Colors.white.withValues(alpha: 0.88),
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      borderRadius: 20,
      borderColor: borderColor.withValues(alpha: 0.5),
      borderWidth: 1,
      duration: const Duration(seconds: 3),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
      animationDuration: const Duration(milliseconds: 400),
      boxShadows: [
        BoxShadow(
          color: borderColor.withValues(alpha: 0.3),
          blurRadius: 20,
          spreadRadius: 0,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }
}
