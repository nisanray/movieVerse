import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../controllers/ai_scout_controller.dart';

class LoadingIndicatorWidget extends StatelessWidget {
  final AiScoutController controller;

  const LoadingIndicatorWidget({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const SpinKitThreeBounce(color: Colors.red, size: 20),
              const SizedBox(width: 12),
              Text(
                'Scout is thinking...',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }
}
