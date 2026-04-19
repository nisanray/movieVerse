import 'package:get/get.dart';
import '../controllers/recommendations_controller.dart';
import '../../domain/repositories/recommendations_repository.dart';
import '../../../ratings/domain/repositories/rating_repository.dart';

class RecommendationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecommendationsController>(
      () => RecommendationsController(
        Get.find<RecommendationsRepository>(),
        Get.find<RatingRepository>(),
      ),
    );
  }
}
