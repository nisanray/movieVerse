import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:marquee/marquee.dart';
import '../controllers/recommendations_controller.dart';
import '../../../media_discovery/presentation/widgets/media_card.dart';
import 'recommendations_list_page.dart';

class RecommendationsPage extends GetView<RecommendationsController> {
  const RecommendationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Gradient (Slightly different from Discovery for distinction)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0F0C29), Color(0xFF1B1B1B), Colors.black],
                ),
              ),
            ),
          ),

          SafeArea(
            child: controller.obx(
              (data) => CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildHeader(),

                  // Section 1: Personalized Picks
                  if (data?['personalized']?.isNotEmpty ?? false) ...[
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                    _buildSectionTitle(
                      'Personalized Picks',
                      Icons.auto_awesome_rounded,
                      action: TextButton(
                        onPressed: () => Get.to(() => RecommendationsListPage(
                              title: 'Personalized Picks',
                              items: data!['personalized']!,
                            )),
                        child: Text(
                          'SEE ALL',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ),
                  ],
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final media = data!['personalized']![index];
                          return MediaCard(media: media)
                              .animate()
                              .fadeIn(delay: (index * 50).ms)
                              .scale(begin: const Offset(0.9, 0.9));
                        },
                        childCount: data!['personalized']!.length > 4
                            ? 4
                            : data!['personalized']!.length,
                      ),
                    ),
                  ),

                  // Section 2: Because you liked...
                  if (data?['similar']?.isNotEmpty ?? false) ...[
                    _buildSectionTitle(
                      'Because you liked ${controller.baseMediaTitle.value}',
                      Icons.favorite_rounded,
                      isMarquee: true,
                      action: TextButton(
                        onPressed: () => Get.to(() => RecommendationsListPage(
                              title:
                                  'Because you liked ${controller.baseMediaTitle.value}',
                              items: data!['similar']!,
                            )),
                        child: Text(
                          'SEE ALL',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return MediaCard(media: data['similar']![index]);
                          },
                          childCount: data['similar']!.length > 4
                              ? 4
                              : data['similar']!.length,
                        ),
                      ),
                    ),
                  ],

                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
              onLoading: const Center(
                child: CircularProgressIndicator(color: Colors.red),
              ),
              onEmpty: _buildEmptyState(),
              onError: (error) => Center(
                child: Text(
                  'Error: $error',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'FOR YOU',
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.red,
                letterSpacing: 4,
              ),
            ).animate().fadeIn().slideX(begin: -0.2),
            const SizedBox(height: 8),
            Text(
              'Intelligent\nDiscovery',
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.1,
              ),
            ).animate().fadeIn(delay: 200.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, {bool isMarquee = false, Widget? action}) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 12, top: 24, bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.red, size: 18),
            const SizedBox(width: 12),
            Expanded(
              child: ShaderMask(
                shaderCallback: (rect) {
                  return const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.black, Colors.black, Colors.transparent],
                    stops: [0.0, 0.9, 1.0],
                  ).createShader(rect);
                },
                blendMode: BlendMode.dstIn,
                child: SizedBox(
                  height: 24,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: isMarquee
                        ? Marquee(
                            text: title.toUpperCase(),
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                              letterSpacing: 1.2,
                              height: 1.0,
                            ),
                            scrollAxis: Axis.horizontal,
                            blankSpace: 40.0,
                            velocity: 30.0,
                            pauseAfterRound: const Duration(seconds: 3),
                            startPadding: 0.0,
                            accelerationDuration: const Duration(seconds: 1),
                            accelerationCurve: Curves.linear,
                            decelerationDuration:
                                const Duration(milliseconds: 500),
                            decelerationCurve: Curves.easeOut,
                          )
                        : Text(
                            title.toUpperCase(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                              letterSpacing: 1.2,
                              height: 1.0,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            if (action != null) action,
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.auto_awesome_rounded,
              size: 100,
              color: Colors.white10,
            ),
            const SizedBox(height: 24),
            Text(
              'Start Your Journey',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Add movies and shows to your watchlist to unlock personalized recommendations.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.white54, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
