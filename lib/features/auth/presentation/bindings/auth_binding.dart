import 'package:get/get.dart';
import '/features/auth/domain/repositories/auth_repository.dart';
import '/features/auth/presentation/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController(Get.find<AuthRepository>()));
  }
}
