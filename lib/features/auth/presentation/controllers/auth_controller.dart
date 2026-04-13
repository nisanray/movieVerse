import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/features/auth/domain/repositories/auth_repository.dart';
import '/features/auth/domain/entities/user_entity.dart';
import '/core/navigation/app_routes.dart';

class AuthController extends GetxController {
  final AuthRepository _repository;

  AuthController(this._repository);

  // Observable user state
  final Rx<UserEntity?> user = Rx<UserEntity?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Bind the observable user to the stream from the repository
    user.bindStream(_repository.onAuthStateChanged);

    // Listen to auth changes to redirect user
    ever(user, _handleAuthRedirect);
  }

  void _handleAuthRedirect(UserEntity? user) {
    if (user != null) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.auth);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _repository.signInWithEmail(email, password);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signup(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _repository.signUpWithEmail(email, password);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _repository.signInWithGoogle();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _repository.signOut();
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _repository.sendPasswordResetEmail(email);
      Get.back(); // Go back to login
      Get.snackbar(
        'Success',
        'Password reset email sent!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.white,
      );
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
