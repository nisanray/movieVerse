import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/domain/repositories/user_repository.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../../core/navigation/app_routes.dart';

class ProfileController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  final UserRepository _userRepository = Get.find<UserRepository>();
  final ImagePicker _picker = ImagePicker();

  final RxBool isLoading = false.obs;
  final RxBool isEditMode = false.obs;
  final Rx<UserEntity?> profileData = Rx<UserEntity?>(null);

  // Smart merge: Prioritize Firestore data but fallback to Auth data for missing fields
  UserEntity? get user {
    final firestoreUser = profileData.value;
    final authUser = _authController.user.value;

    if (firestoreUser == null) return authUser;
    if (authUser == null) return firestoreUser;

    return UserEntity(
      uid: authUser.uid,
      email: firestoreUser.email ?? authUser.email,
      displayName: firestoreUser.displayName ?? authUser.displayName,
      photoUrl: firestoreUser.photoUrl ?? authUser.photoUrl,
      bio: firestoreUser.bio,
    );
  }

  void toggleEditMode() {
    isEditMode.value = !isEditMode.value;
  }

  @override
  void onInit() {
    super.onInit();
    // Reactively listen to user auth changes
    // This handles the transition from Guest to Signed-in automatically
    ever(_authController.user, (_) => _listenToProfileChanges());
    _listenToProfileChanges(); // Initial check
  }

  void _listenToProfileChanges() {
    final currentUser = _authController.user.value;
    if (kDebugMode) {
      debugPrint('DEBUG: _listenToProfileChanges called. User: ${currentUser?.uid}');
    }

    if (currentUser != null) {
      // Bind the observable to the Firestore stream for this user
      if (kDebugMode) {
        debugPrint('DEBUG: Binding Profile Stream for ${currentUser.uid}');
      }
      profileData.bindStream(
        _userRepository.getUserProfile(currentUser.uid).map((data) {
          if (kDebugMode) {
            debugPrint('DEBUG: Profile Stream emitted: ${data?.displayName}, bio: ${data?.bio}');
          }
          return data;
        }),
      );
    } else {
      // Clear local profile data if user logs out or is a guest
      if (kDebugMode) {
        debugPrint('DEBUG: Clearing profile data (Guest/Logout)');
      }
      profileData.value = null;
    }
  }

  Future<void> updateBio(String bio) async {
    if (user == null) return;
    try {
      isLoading.value = true;
      final updatedUser = UserEntity(
        uid: user!.uid,
        email: user!.email,
        displayName: user!.displayName,
        photoUrl: user!.photoUrl,
        bio: bio,
      );
      await _userRepository.updateProfile(updatedUser);
      SnackbarUtils.success(title: 'Success', message: 'Bio updated!');
    } catch (e) {
      SnackbarUtils.error(title: 'Error', message: 'Could not update bio');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateDisplayName(String name) async {
    if (user == null) return;
    try {
      isLoading.value = true;
      final updatedUser = UserEntity(
        uid: user!.uid,
        email: user!.email,
        displayName: name,
        photoUrl: user!.photoUrl,
        bio: user!.bio,
      );
      await _userRepository.updateProfile(updatedUser);
      SnackbarUtils.success(title: 'Success', message: 'Name updated!');
    } catch (e) {
      SnackbarUtils.error(title: 'Error', message: 'Could not update name');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickAndUploadImage() async {
    SnackbarUtils.info(
      title: 'Coming Soon',
      message: 'Profile picture uploads will be available in the next update!',
    );
    /* 
    if (user == null) return;
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 512,
      );
      // ... rest of the code is already commented out
    } catch (e) { ... }
    */
  }

  Future<void> logout() async {
    await _authController.logout();
  }

  void goToSignIn() {
    Get.toNamed(AppRoutes.auth);
  }
}
