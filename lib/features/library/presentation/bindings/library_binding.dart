import 'package:get/get.dart';
import '../../../watch_later/presentation/controllers/watch_later_controller.dart';
import '../../../watch_later/domain/repositories/watch_later_repository.dart';
import '../../../watch_later/data/repositories/watch_later_repository_impl.dart';
import '../../../watch_later/domain/usecases/get_watch_later_use_case.dart';
import '../../../watch_later/domain/usecases/add_to_watch_later_use_case.dart';
import '../../../watch_later/domain/usecases/remove_from_watch_later_use_case.dart';
import '../../../watched/presentation/controllers/watched_controller.dart';
import '../../../watched/domain/repositories/watched_repository.dart';
import '../../../watched/data/repositories/watched_repository_impl.dart';
import '../../../watched/domain/usecases/get_watched_use_case.dart';
import '../../../watched/domain/usecases/add_to_watched_use_case.dart';
import '../../../watched/domain/usecases/remove_from_watched_use_case.dart';
import '../../../ratings/presentation/controllers/my_ratings_controller.dart';
import '../../../ratings/data/repositories/rating_repository_impl.dart';

class LibraryBinding extends Bindings {
  @override
  void dependencies() {
    // Watch Later Dependencies
    if (!Get.isRegistered<WatchLaterRepository>()) {
      Get.lazyPut<WatchLaterRepository>(() => WatchLaterRepositoryImpl());
    }
    if (!Get.isRegistered<WatchLaterController>()) {
      Get.lazyPut(() {
        final repo = Get.find<WatchLaterRepository>();
        return WatchLaterController(
          GetWatchLaterUseCase(repo),
          AddToWatchLaterUseCase(repo),
          RemoveFromWatchLaterUseCase(repo),
        );
      });
    }

    // Watched Dependencies
    if (!Get.isRegistered<WatchedRepository>()) {
      Get.lazyPut<WatchedRepository>(() => WatchedRepositoryImpl());
    }
    if (!Get.isRegistered<WatchedController>()) {
      Get.lazyPut(() {
        final watchedRepo = Get.find<WatchedRepository>();
        final watchLaterRepo = Get.find<WatchLaterRepository>();
        return WatchedController(
          GetWatchedUseCase(watchedRepo),
          AddToWatchedUseCase(
            watchedRepository: watchedRepo,
            watchLaterRepository: watchLaterRepo,
          ),
          RemoveFromWatchedUseCase(watchedRepo),
        );
      });
    }

    // Ratings Dependencies
    Get.lazyPut(() => MyRatingsController(RatingRepositoryImpl()));
  }
}
