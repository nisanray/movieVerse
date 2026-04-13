import 'package:get/get.dart';
import '../../domain/repositories/watchlist_repository.dart';
import '../../data/repositories/watchlist_repository_impl.dart';
import '../controllers/watchlist_controller.dart';

class WatchlistBinding extends Bindings {
  @override
  void dependencies() {
    final repository = Get.put<WatchlistRepository>(WatchlistRepositoryImpl());
    Get.put(WatchlistController(repository), permanent: true);
  }
}
