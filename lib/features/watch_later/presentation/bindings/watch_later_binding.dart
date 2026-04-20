import 'package:get/get.dart';
import '../../domain/repositories/watch_later_repository.dart';
import '../../data/repositories/watch_later_repository_impl.dart';
import '../controllers/watch_later_controller.dart';
import '../../domain/usecases/get_watch_later_use_case.dart';
import '../../domain/usecases/add_to_watch_later_use_case.dart';
import '../../domain/usecases/remove_from_watch_later_use_case.dart';

class WatchLaterBinding extends Bindings {
  @override
  void dependencies() {
    final repository = Get.put<WatchLaterRepository>(WatchLaterRepositoryImpl());
    
    Get.put(WatchLaterController(
      GetWatchLaterUseCase(repository),
      AddToWatchLaterUseCase(repository),
      RemoveFromWatchLaterUseCase(repository),
    ), permanent: true);
  }
}
