import 'package:get/get.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/watchlist/domain/repositories/watchlist_repository.dart';
import '../../features/watchlist/data/repositories/watchlist_repository_impl.dart';
import '../../features/watchlist/presentation/controllers/watchlist_controller.dart';
import '../../features/auth/domain/repositories/user_repository.dart';
import '../../features/auth/data/repositories/user_repository_impl.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Repositories
    final authRepo = Get.put<AuthRepository>(AuthRepositoryImpl(), permanent: true);
    final watchlistRepo = Get.put<WatchlistRepository>(WatchlistRepositoryImpl(), permanent: true);
    Get.put<UserRepository>(UserRepositoryImpl(), permanent: true);
    
    // Global Controllers
    Get.put(AuthController(authRepo), permanent: true);
    Get.put(WatchlistController(watchlistRepo), permanent: true);
  }
}
