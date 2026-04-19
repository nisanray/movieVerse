import 'package:get/get.dart';
import '../../domain/repositories/ai_scout_repository.dart';
import '../../data/repositories/ai_scout_repository_impl.dart';
import '../controllers/ai_scout_controller.dart';

class AiScoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AiScoutRepository>(() => AiScoutRepositoryImpl());
    Get.lazyPut(() => AiScoutController());
  }
}
