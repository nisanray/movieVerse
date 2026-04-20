import 'package:flutter/material.dart';
import '../controllers/profile_controller.dart';

class AvatarWidget extends StatelessWidget {
  final ProfileController controller;

  const AvatarWidget({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(colors: [Colors.red, Colors.orange]),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 60,
        backgroundColor: Colors.grey[900],
        backgroundImage: controller.user?.photoUrl != null
            ? NetworkImage(controller.user!.photoUrl!)
            : null,
        child: controller.user?.photoUrl == null
            ? const Icon(Icons.person, size: 60, color: Colors.white24)
            : null,
      ),
    );
  }
}
