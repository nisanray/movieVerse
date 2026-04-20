import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class LogoutButtonWidget extends StatelessWidget {
  final ProfileController controller;

  const LogoutButtonWidget({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isGuest = controller.user == null;
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => isGuest ? controller.goToSignIn() : controller.logout(),
          icon: Icon(isGuest ? Icons.login_rounded : Icons.logout_rounded),
          label: Text(isGuest ? 'SIGN IN' : 'SIGN OUT'),
          style: ElevatedButton.styleFrom(
            backgroundColor: isGuest ? Colors.red : Colors.white.withOpacity(0.05),
            foregroundColor: isGuest ? Colors.white : Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isGuest ? Colors.transparent : Colors.red,
                width: 0.5,
              ),
            ),
            elevation: isGuest ? 8 : 0,
            shadowColor: isGuest ? Colors.red.withOpacity(0.4) : Colors.transparent,
          ),
        ),
      );
    });
  }
}
