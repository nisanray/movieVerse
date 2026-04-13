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
    // 1. Check Auth State first (Implicit onboarding completion)
    if (user != null) {
      _storageService.setOnboardingCompleted(true);
      Get.offAllNamed(AppRoutes.home);
      return;
    }

    // 2. Check Explicit Onboarding Flag
    if (!_storageService.isOnboardingCompleted()) {
      Get.offAllNamed(AppRoutes.onboarding);
      return;
    }
    
    Get.offAllNamed(AppRoutes.auth);
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
