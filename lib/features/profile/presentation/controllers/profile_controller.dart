import 'package:get/get.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class ProfileController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();

  // Use the user from AuthController
  UserEntity? get user => _authController.user.value;

  Future<void> logout() async {
    await _authController.logout();
  }
}
