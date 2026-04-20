import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controllers/watch_later_controller.dart';
import '../../../media_discovery/presentation/widgets/media_card.dart';
import '../widgets/empty_state_widget.dart';

class WatchLaterPage extends GetView<WatchLaterController> {
  const WatchLaterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Watch Later',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),
        ),
      ),
      body: controller.obx(
        (watchLaterList) => GridView.builder(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 70,
            left: 16,
            right: 16,
            bottom: 24,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: watchLaterList!.length,
          itemBuilder: (context, index) {
            return MediaCard(media: watchLaterList[index])
                .animate(delay: (index * 100).ms)
                .fadeIn(duration: 500.ms)
                .slideY(begin: 0.2, end: 0, curve: Curves.easeOut);
          },
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
    );
  }
}
