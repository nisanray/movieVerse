import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../watchlist/presentation/controllers/watchlist_controller.dart';
import '../../../ratings/presentation/controllers/my_ratings_controller.dart';
import '../widgets/sliver_app_bar_widget.dart';
import '../widgets/watchlist_tab_widget.dart';
import '../widgets/ratings_tab_widget.dart';

class MyLibraryPage extends StatelessWidget {
  const MyLibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure both controllers are available
    final watchlistController = Get.find<WatchlistController>();
    final ratingsController = Get.find<MyRatingsController>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Background Gradient (Matched to "For You" page)
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF0F0C29),
                      Color(0xFF1B1B1B),
                      Colors.black,
                    ],
                  ),
                ),
              ),
            ),
            NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [const LibrarySliverAppBarWidget()];
              },
              body: TabBarView(
                children: [
                  WatchlistTabWidget(controller: watchlistController),
                  RatingsTabWidget(controller: ratingsController),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
