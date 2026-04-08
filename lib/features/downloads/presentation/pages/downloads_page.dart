import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/downloads_controller.dart';

class DownloadsPage extends GetView<DownloadsController> {
  const DownloadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Downloads')),
      body: Center(child: Text('Downloads Page')),
    );
  }
}
