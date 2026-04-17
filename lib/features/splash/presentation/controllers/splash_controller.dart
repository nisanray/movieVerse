import 'package:get/get.dart';
import '../../../../core/utils/storage_service.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class SplashController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  final AuthController _authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // Wait for a small duration for a smooth branded entrance
    await Future.delayed(const Duration(milliseconds: 2000));

    // 1. Check Auth State first (Implicit onboarding completion)
    if (_authController.user.value != null) {
      _storageService.setOnboardingCompleted(true);
      Get.offAllNamed(AppRoutes.home);
      return;
    }

    // 2. Check Explicit Onboarding Flag
    if (!_storageService.isOnboardingCompleted()) {
      Get.offAllNamed(AppRoutes.onboarding);
      return;
    }

    // If onboarding is done, take them to Home (Guest Mode)
    // AuthController will handle the authenticated state redirect if needed.
    Get.offAllNamed(AppRoutes.home);
  }
}
