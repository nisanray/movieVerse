import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/ai_scout_controller.dart';

class AiScoutAppBarWidget extends StatelessWidget {
  final AiScoutController controller;

  const AiScoutAppBarWidget({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                onPressed: () => Get.back(),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red.withOpacity(0.5)),
                ),
                child: const Icon(Icons.auto_awesome_rounded, color: Colors.red, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MOVIE SCOUT',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      'AI Intelligence',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete_sweep_rounded, color: Colors.white.withOpacity(0.5)),
                onPressed: () => _showClearDialog(context),
                tooltip: 'Clear History',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showClearDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Text('Clear History?', style: GoogleFonts.poppins(color: Colors.white)),
        content: Text('This will permanently delete your chat history with the Scout.',
          style: GoogleFonts.poppins(color: Colors.white70)),
        actions: [
          TextButton(
            child: Text('Cancel', style: GoogleFonts.poppins(color: Colors.white)),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: Text('Clear', style: GoogleFonts.poppins(color: Colors.red)),
            onPressed: () {
              controller.clearChat();
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
