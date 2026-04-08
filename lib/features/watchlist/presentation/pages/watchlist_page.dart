import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/watchlist_controller.dart';

class WatchlistPage extends GetView<WatchlistController> {
  const WatchlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Watchlist')),
      body: Center(child: Text('Watchlist Page')),
    );
  }
}
