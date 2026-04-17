import 'package:get/get.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../../core/utils/storage_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user_entity.dart';
import '../../../../core/navigation/app_routes.dart';

class AuthController extends GetxController {
  final AuthRepository _repository;
  final StorageService _storageService = Get.find<StorageService>();

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
    // 1. If user is authenticated, always take them home
    if (user != null) {
      _storageService.setOnboardingCompleted(true);
      Get.offAllNamed(AppRoutes.home);
      return;
    }

    // 2. If user is NOT authenticated, check onboarding
    if (!_storageService.isOnboardingCompleted()) {
      Get.offAllNamed(AppRoutes.onboarding);
      return;
    }
    
    // 3. If onboarding is complete, they can stay as Guests.
    // We only force a redirect if they are currently on a restricted page 
    // or if we're initializing and they aren't anywhere yet.
    // For now, if they are null and onboarding is done, let them land on Home.
    // IMPORTANT: Don't redirect if they are already on the Auth page!
    if (Get.currentRoute != AppRoutes.auth && Get.currentRoute != AppRoutes.forgotPassword) {
      Get.offAllNamed(AppRoutes.home);
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
      SnackbarUtils.success(
        title: 'Email Sent!',
        message: 'Check your inbox to reset your password.',
      );
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
