import 'package:get/get.dart';
import '../../../watchlist/presentation/controllers/watchlist_controller.dart';
import '../../../watchlist/domain/repositories/watchlist_repository.dart';
import '../../../watchlist/data/repositories/watchlist_repository_impl.dart';
import '../../../ratings/presentation/controllers/my_ratings_controller.dart';
import '../../../ratings/data/repositories/rating_repository_impl.dart';

class LibraryBinding extends Bindings {
  @override
  void dependencies() {
    // Watchlist Dependencies
    if (!Get.isRegistered<WatchlistRepository>()) {
      Get.lazyPut<WatchlistRepository>(() => WatchlistRepositoryImpl());
    }
    if (!Get.isRegistered<WatchlistController>()) {
      Get.lazyPut(() => WatchlistController(Get.find<WatchlistRepository>()));
    }

    // Ratings Dependencies
    Get.lazyPut(() => MyRatingsController(RatingRepositoryImpl()));
  }
}
