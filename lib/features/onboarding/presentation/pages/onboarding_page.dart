import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_assets.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingPage extends GetView<OnboardingController> {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060E20),
      body: Stack(
        children: [
          // Hero Background Layer
          Positioned.fill(
            child: Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDy4j-7FjmGpJKXLCXARioiK8fNiNJp_7gvSlapa74wieZ5m4N0vIq8Om4OvO6043h4u7NIeFQF-3-47WhrEgE2907bSXJ4KbyhhyNFwh23F5sdlmEV_yuTUJI1KOBw38BSqBv1faPCctJs3jRI8Axtim32oB1l92uqDXoLZRVdRfu82LUWHrVKC-1ozD_EgYyDjuyfRelVn4kkOu-cZkInmEiDbdIzaneLO1lpO63fKNiKIZaW3-tbRFpoGBqzKr6ru59L9oqFZ5w',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: Colors.black),
            ),
          ),
          // Cinematic Vignette
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF060E20).withAlpha(204), // 0.8 * 255
                    const Color(0xFF060E20).withAlpha(102), // 0.4 * 255
                    const Color(0xFF060E20),
                  ],
                  stops: const [0.0, 0.5, 0.85],
                ),
              ),
            ),
          ),
          // Foreground Content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Branding Header
                            Column(
                              children: [
                                Image.asset(
                                  AppAssets.logo,
                                  height: 180,
                                  fit: BoxFit.fitHeight,
                                ),
                                SizedBox(height: 10),
                                ShaderMask(
                                  shaderCallback: (bounds) =>
                                      const LinearGradient(
                                        colors: [
                                          Color.fromARGB(255, 14, 141, 153),
                                          Color(0xFF9695FF),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ).createShader(bounds),
                                  child: Text(
                                    'MOVIE VERSE',
                                    style: GoogleFonts.manrope(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -1.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 60), // Gap
                            // Content Canvas
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: GoogleFonts.manrope(
                                  fontSize: 45,
                                  height: 1.1,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                                children: [
                                  const TextSpan(text: 'The Digital\n'),
                                  TextSpan(
                                    text: 'Curator.',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Experience cinema through a lens of smart discovery. Personalized recommendations that understand your taste before you do.',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                color: Colors.white70,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 48),
                            // CTA Buttons
                            SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: ElevatedButton(
                                onPressed: controller.getStarted,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFA5A5FF),
                                  foregroundColor: const Color(0xFF19059D),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 8,
                                ),
                                child: const Text(
                                  'Get Started',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: OutlinedButton(
                                onPressed: controller.signIn,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.white10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
