import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/movie_details_controller.dart';

class MovieDetailsPage extends GetView<MovieDetailsController> {
  const MovieDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MovieDetails')),
      body: Center(child: Text('MovieDetails Page')),
    );
  }
}
