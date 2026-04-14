import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/domain/repositories/user_repository.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../../core/utils/snackbar_utils.dart';

class ProfileController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  final UserRepository _userRepository = Get.find<UserRepository>();
  final ImagePicker _picker = ImagePicker();

  final RxBool isLoading = false.obs;
  final RxBool isEditMode = false.obs;
  final Rx<UserEntity?> profileData = Rx<UserEntity?>(null);

  // Use the user from AuthController as fallback
  UserEntity? get user => profileData.value ?? _authController.user.value;

  void toggleEditMode() {
    isEditMode.value = !isEditMode.value;
  }

  @override
  void onInit() {
    super.onInit();
    final currentUser = _authController.user.value;
    if (currentUser != null) {
      profileData.bindStream(_userRepository.getUserProfile(currentUser.uid));
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
}
