import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../../../media_discovery/presentation/controllers/media_discovery_controller.dart';
import '../../../profile/presentation/controllers/profile_controller.dart';
import '../../../media_discovery/data/datasources/media_remote_data_source.dart';
import '../../../media_discovery/data/repositories/media_repository_impl.dart';
import '../../../media_discovery/domain/repositories/media_repository.dart';
import '../../../recommendations/data/repositories/recommendations_repository_impl.dart';
import '../../../recommendations/domain/repositories/recommendations_repository.dart';
import '../../../recommendations/presentation/controllers/recommendations_controller.dart';
import '../../../../core/api/api_client.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());

    // Media Discovery (the Discovery tab is rendered inside an IndexedStack,
    // so its binding won't run via routing; we register its deps here).
    Get.lazyPut<MediaRemoteDataSource>(
      () => MediaRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<MediaRepository>(
      () => MediaRepositoryImpl(
        remoteDataSource: Get.find<MediaRemoteDataSource>(),
      ),
      fenix: true,
    );
    Get.lazyPut<MediaDiscoveryController>(
      () => MediaDiscoveryController(Get.find<MediaRepository>()),
      fenix: true,
    );
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);

    // Recommendations
    Get.lazyPut<RecommendationsRepository>(
      () => RecommendationsRepositoryImpl(Get.find<ApiClient>()),
    );
    Get.lazyPut<RecommendationsController>(
      () => RecommendationsController(Get.find<RecommendationsRepository>()),
      fenix: true,
    );
  }
}
