import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../widgets/bottom_nav_widget.dart';
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
            child: BottomNavWidget(controller: controller),
          ),
        ],
      ),
    );
  }
}
