import 'package:get/get.dart';
import 'package:movie_verse/features/auth/presentation/controllers/auth_controller.dart';
import 'package:movie_verse/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:movie_verse/features/auth/domain/repositories/auth_repository.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Repositories
    final authRepo = Get.put<AuthRepository>(AuthRepositoryImpl(), permanent: true);
    
    // Global Controllers
    Get.put(AuthController(authRepo), permanent: true);
  }
}
