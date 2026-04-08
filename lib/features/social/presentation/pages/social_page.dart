import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/social_controller.dart';

class SocialPage extends GetView<SocialController> {
  const SocialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Social')),
      body: Center(child: Text('Social Page')),
    );
  }
}
