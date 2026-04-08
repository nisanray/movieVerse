import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/recommendations_controller.dart';

class RecommendationsPage extends GetView<RecommendationsController> {
  const RecommendationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recommendations')),
      body: Center(child: Text('Recommendations Page')),
    );
  }
}
