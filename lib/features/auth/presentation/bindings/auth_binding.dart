import 'package:get/get.dart';
import 'package:movie_verse/features/auth/domain/repositories/auth_repository.dart';
import 'package:movie_verse/features/auth/presentation/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController(Get.find<AuthRepository>()));
  }
}
