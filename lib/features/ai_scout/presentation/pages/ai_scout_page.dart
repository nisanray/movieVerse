import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ai_scout_controller.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/message_bubble_widget.dart';
import '../widgets/loading_indicator_widget.dart';
import '../widgets/input_area_widget.dart';

class AiScoutPage extends GetView<AiScoutController> {
  const AiScoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Deep Space Background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF000000),
                    Color(0xFF0F0C29),
                    Color(0xFF302B63),
                  ],
                ),
              ),
            ),
          ),

          // Main Chat Area
          SafeArea(
            child: Column(
              children: [
                AiScoutAppBarWidget(controller: controller),
                Expanded(
                  child: Obx(
                    () => ListView.builder(
                      controller: controller.scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      itemCount: controller.messages.length,
                      itemBuilder: (context, index) {
                        final message = controller.messages[index];
                        return MessageBubbleWidget(message: message);
                      },
                    ),
                  ),
                ),
                LoadingIndicatorWidget(controller: controller),
                InputAreaWidget(controller: controller),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
