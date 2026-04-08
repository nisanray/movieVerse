import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/movie_discovery_controller.dart';

class MovieDiscoveryPage extends GetView<MovieDiscoveryController> {
  const MovieDiscoveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MovieDiscovery')),
      body: Center(child: Text('MovieDiscovery Page')),
    );
  }
}
