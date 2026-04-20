import 'package:get/get.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/watch_later/domain/repositories/watch_later_repository.dart';
import '../../features/watch_later/data/repositories/watch_later_repository_impl.dart';
import '../../features/watch_later/presentation/controllers/watch_later_controller.dart';
import '../../features/watch_later/domain/usecases/get_watch_later_use_case.dart';
import '../../features/watch_later/domain/usecases/add_to_watch_later_use_case.dart';
import '../../features/watch_later/domain/usecases/remove_from_watch_later_use_case.dart';
import '../../features/watched/domain/repositories/watched_repository.dart';
import '../../features/watched/data/repositories/watched_repository_impl.dart';
import '../../features/watched/presentation/controllers/watched_controller.dart';
import '../../features/watched/domain/usecases/get_watched_use_case.dart';
import '../../features/watched/domain/usecases/add_to_watched_use_case.dart';
import '../../features/watched/domain/usecases/remove_from_watched_use_case.dart';
import '../../features/auth/domain/repositories/user_repository.dart';
import '../../features/auth/data/repositories/user_repository_impl.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Repositories
    final authRepo = Get.put<AuthRepository>(AuthRepositoryImpl(), permanent: true);
    final watchLaterRepo = Get.put<WatchLaterRepository>(WatchLaterRepositoryImpl(), permanent: true);
    final watchedRepo = Get.put<WatchedRepository>(WatchedRepositoryImpl(), permanent: true);
    Get.put<UserRepository>(UserRepositoryImpl(), permanent: true);
    
    // Global Controllers
    Get.put(AuthController(authRepo), permanent: true);
    
    Get.put(WatchLaterController(
      GetWatchLaterUseCase(watchLaterRepo),
      AddToWatchLaterUseCase(watchLaterRepo),
      RemoveFromWatchLaterUseCase(watchLaterRepo),
    ), permanent: true);

    Get.put(WatchedController(
      GetWatchedUseCase(watchedRepo),
      AddToWatchedUseCase(
        watchedRepository: watchedRepo,
        watchLaterRepository: watchLaterRepo,
      ),
      RemoveFromWatchedUseCase(watchedRepo),
    ), permanent: true);
  }
}
