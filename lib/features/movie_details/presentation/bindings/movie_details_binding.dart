import 'package:get/get.dart';
import '../../../../core/api/api_client.dart';
import '../../data/datasources/movie_details_remote_data_source.dart';
import '../../data/repositories/movie_details_repository_impl.dart';
import '../../domain/repositories/movie_details_repository.dart';
import '../controllers/movie_details_controller.dart';

class MovieDetailsBinding extends Bindings {
  @override
  void dependencies() {
    final int movieId = Get.arguments as int;

    Get.lazyPut<MovieDetailsRemoteDataSource>(
      () => MovieDetailsRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
    );

    Get.lazyPut<MovieDetailsRepository>(
      () => MovieDetailsRepositoryImpl(
        remoteDataSource: Get.find<MovieDetailsRemoteDataSource>(),
      ),
    );

    Get.put(MovieDetailsController(Get.find<MovieDetailsRepository>(), movieId));
  }
}
