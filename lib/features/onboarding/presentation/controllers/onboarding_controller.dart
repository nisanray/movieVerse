import 'package:get/get.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/utils/storage_service.dart';

class OnboardingController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  void getStarted() async {
    await _storageService.setOnboardingCompleted(true);
    Get.offAllNamed(AppRoutes.home); // Navigate to Home and clear stack
  }

  void signIn() {
    Get.toNamed(AppRoutes.auth);
  }
}
