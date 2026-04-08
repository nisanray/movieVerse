import 'package:get/get.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Inject global dependencies here (e.g., API services, local storage)
    // Get.lazyPut<ApiClient>(() => ApiClient());
  }
}
