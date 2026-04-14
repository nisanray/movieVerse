import 'package:get/get.dart';
import '../../../../core/api/api_client.dart';
import '../../data/datasources/media_remote_data_source.dart';
import '../../data/repositories/media_repository_impl.dart';
import '../../domain/repositories/media_repository.dart';
import '../controllers/media_discovery_controller.dart';

class MediaDiscoveryBinding extends Bindings {
  @override
  void dependencies() {
    // Data Sources
    Get.lazyPut<MediaRemoteDataSource>(
      () => MediaRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
    );

    // Repositories
    Get.lazyPut<MediaRepository>(
      () => MediaRepositoryImpl(remoteDataSource: Get.find<MediaRemoteDataSource>()),
    );

    // Controllers
    Get.lazyPut(() => MediaDiscoveryController(Get.find<MediaRepository>()));
  }
}
