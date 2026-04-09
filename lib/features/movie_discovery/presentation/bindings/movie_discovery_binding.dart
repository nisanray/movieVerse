import 'package:get/get.dart';
import '../../../../core/api/api_client.dart';
import '../../data/datasources/movie_remote_data_source.dart';
import '../../data/repositories/movie_repository_impl.dart';
import '../../domain/repositories/movie_repository.dart';
import '../controllers/movie_discovery_controller.dart';

class MovieDiscoveryBinding extends Bindings {
  @override
  void dependencies() {
    // Data Sources
    Get.lazyPut<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
    );

    // Repositories
    Get.lazyPut<MovieRepository>(
      () => MovieRepositoryImpl(remoteDataSource: Get.find<MovieRemoteDataSource>()),
    );

    // Controllers
    Get.lazyPut(() => MovieDiscoveryController(Get.find<MovieRepository>()));
  }
}
