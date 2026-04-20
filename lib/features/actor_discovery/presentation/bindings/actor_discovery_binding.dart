import 'package:get/get.dart';
import '../../../../core/api/api_client.dart';
import '../../data/datasources/actor_remote_data_source.dart';
import '../../data/repositories/actor_repository_impl.dart';
import '../../domain/repositories/actor_repository.dart';
import '../../domain/usecases/get_media_by_actor_usecase.dart';
import '../controllers/actor_discovery_controller.dart';

class ActorDiscoveryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActorRemoteDataSource>(
      () => ActorRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
    );
    Get.lazyPut<ActorRepository>(
      () => ActorRepositoryImpl(remoteDataSource: Get.find<ActorRemoteDataSource>()),
    );
    Get.lazyPut<GetMediaByActorUseCase>(
      () => GetMediaByActorUseCase(Get.find<ActorRepository>()),
    );
    Get.lazyPut<ActorDiscoveryController>(
      () => ActorDiscoveryController(Get.find<GetMediaByActorUseCase>()),
    );
  }
}
