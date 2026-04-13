import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controllers/splash_controller.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    // We initialize the controller here to trigger navigation logic
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Branded Logo with premium animation
            Image.asset(
              'assets/logo/logo_512x512.png',
              height: 120,
              width: 120,
            )
            .animate()
            .fadeIn(duration: 800.ms)
            .scale(delay: 200.ms, duration: 600.ms, curve: Curves.easeOutBack),
            
            const SizedBox(height: 24),
            
            // App Name with letter spacing
            const Text(
              'MOVIE VERSE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            )
            .animate()
            .fadeIn(delay: 500.ms, duration: 800.ms),
          ],
        ),
      ),
    );
  }
}
