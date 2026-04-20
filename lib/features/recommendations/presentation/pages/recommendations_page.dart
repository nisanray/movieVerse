import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controllers/recommendations_controller.dart';
import '../../../media_discovery/presentation/widgets/media_card.dart';
import '../widgets/header_widget.dart';
import '../widgets/section_title_widget.dart';
import '../widgets/empty_state_widget.dart';
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
                  const HeaderWidget(),

                  // Section 1: Personalized Picks
                  if (data?['personalized']?.isNotEmpty ?? false) ...[
                    SectionTitleWidget(
                      title: 'Personalized Picks',
                      icon: Icons.auto_awesome_rounded,
                      action: TextButton(
                        onPressed: () => Get.to(
                          () => RecommendationsListPage(
                            title: 'Personalized Picks',
                            items: data?['personalized'] ?? [],
                          ),
                        ),
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
                          final personalized = data?['personalized'] ?? [];
                          if (index >= personalized.length)
                            return const SizedBox.shrink();
                          final media = personalized[index];
                          return MediaCard(media: media)
                              .animate()
                              .fadeIn(delay: (index * 50).ms)
                              .scale(begin: const Offset(0.9, 0.9));
                        },
                        childCount: (data?['personalized']?.length ?? 0) > 4
                            ? 4
                            : (data?['personalized']?.length ?? 0),
                      ),
                    ),
                  ),

                  // Section 2: Because you liked...
                  if (data?['similar']?.isNotEmpty ?? false) ...[
                    SectionTitleWidget(
                      title:
                          'Because you liked ${controller.baseMediaTitle.value}',
                      icon: Icons.favorite_rounded,
                      isMarquee: true,
                      action: TextButton(
                        onPressed: () => Get.to(
                          () => RecommendationsListPage(
                            title:
                                'Because you liked ${controller.baseMediaTitle.value}',
                            items: data?['similar'] ?? [],
                          ),
                        ),
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
                            final similar = data?['similar'] ?? [];
                            if (index >= similar.length)
                              return const SizedBox.shrink();
                            return MediaCard(media: similar[index]);
                          },
                          childCount: (data?['similar']?.length ?? 0) > 4
                              ? 4
                              : (data?['similar']?.length ?? 0),
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
              onEmpty: const EmptyStateWidget(),
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
}
