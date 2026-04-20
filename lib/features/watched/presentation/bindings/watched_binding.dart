import 'package:get/get.dart';
import '../../domain/repositories/watched_repository.dart';
import '../../data/repositories/watched_repository_impl.dart';
import '../../../watch_later/domain/repositories/watch_later_repository.dart';
import '../../../watch_later/data/repositories/watch_later_repository_impl.dart';
import '../controllers/watched_controller.dart';
import '../../domain/usecases/get_watched_use_case.dart';
import '../../domain/usecases/add_to_watched_use_case.dart';
import '../../domain/usecases/remove_from_watched_use_case.dart';

class WatchedBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Ensure Repositories are available (may already be in InitialBinding)
    if (!Get.isRegistered<WatchedRepository>()) {
      Get.lazyPut<WatchedRepository>(() => WatchedRepositoryImpl());
    }
    
    // We need WatchLaterRepository for mutual exclusivity in AddToWatched
    if (!Get.isRegistered<WatchLaterRepository>()) {
      Get.lazyPut<WatchLaterRepository>(() => WatchLaterRepositoryImpl());
    }

    final watchedRepo = Get.find<WatchedRepository>();
    final watchLaterRepo = Get.find<WatchLaterRepository>();

    // 2. Controller with Use Cases
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
