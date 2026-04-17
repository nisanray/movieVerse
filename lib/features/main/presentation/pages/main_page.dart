import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../../../media_discovery/presentation/pages/media_discovery_page.dart';
import '../../../library/presentation/pages/my_library_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../recommendations/presentation/pages/recommendations_page.dart';

class MainPage extends GetView<MainController> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const MediaDiscoveryPage(),
      const RecommendationsPage(),
      const MyLibraryPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: Obx(
              () => IndexedStack(
                index: controller.currentIndex.value,
                children: pages,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomNav(context),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    // Floating pill only (no full-width background). This is meant to be used
    // as an overlay inside a Stack so the area outside the pill shows content.
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: bottomInset > 0 ? bottomInset : 8,
      ),
      child: SizedBox(
        height: 56,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(96),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      scheme.onSurface.withAlpha(32),
                      scheme.onSurface.withAlpha(14),
                    ],
                  ),
                  border: Border.all(
                    color: scheme.onSurface.withAlpha(30),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Obx(
                  () => BottomNavigationBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    type: BottomNavigationBarType.fixed,
                    currentIndex: controller.currentIndex.value,
                    onTap: controller.changeTabIndex,
                    iconSize: 20,
                    // Colors / typography come from AppTheme.bottomNavigationBarTheme
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.explore_outlined),
                        activeIcon: Icon(Icons.explore_rounded),
                        label: 'Discovery',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.auto_awesome_outlined),
                        activeIcon: Icon(Icons.auto_awesome_rounded),
                        label: 'For You',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.video_library_outlined),
                        activeIcon: Icon(Icons.video_library_rounded),
                        label: 'Library',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person_outline_rounded),
                        activeIcon: Icon(Icons.person_rounded),
                        label: 'Profile',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
