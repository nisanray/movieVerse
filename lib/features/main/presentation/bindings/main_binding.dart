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
import '../../../ratings/data/repositories/rating_repository_impl.dart';
import '../../../ratings/domain/repositories/rating_repository.dart';
import '../../../ratings/presentation/controllers/my_ratings_controller.dart';
import '../../../watch_later/data/repositories/watch_later_repository_impl.dart';
import '../../../watch_later/domain/repositories/watch_later_repository.dart';
import '../../../watch_later/presentation/controllers/watch_later_controller.dart';
import '../../../watch_later/domain/usecases/get_watch_later_use_case.dart';
import '../../../watch_later/domain/usecases/add_to_watch_later_use_case.dart';
import '../../../watch_later/domain/usecases/remove_from_watch_later_use_case.dart';
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

    // Ratings (Global)
    Get.lazyPut<RatingRepository>(() => RatingRepositoryImpl(), fenix: true);
    Get.lazyPut(
      () => MyRatingsController(Get.find<RatingRepository>()),
      fenix: true,
    );

    // Watch Later (Global)
    if (!Get.isRegistered<WatchLaterRepository>()) {
      Get.lazyPut<WatchLaterRepository>(
        () => WatchLaterRepositoryImpl(),
        fenix: true,
      );
    }
    if (!Get.isRegistered<WatchLaterController>()) {
      Get.lazyPut(
        () {
          final repo = Get.find<WatchLaterRepository>();
          return WatchLaterController(
            GetWatchLaterUseCase(repo),
            AddToWatchLaterUseCase(repo),
            RemoveFromWatchLaterUseCase(repo),
          );
        },
        fenix: true,
      );
    }

    // Recommendations
    Get.lazyPut<RecommendationsRepository>(
      () => RecommendationsRepositoryImpl(Get.find<ApiClient>()),
    );
    Get.lazyPut<RecommendationsController>(
      () => RecommendationsController(
        Get.find<RecommendationsRepository>(),
        Get.find<RatingRepository>(),
      ),
      fenix: true,
    );
  }
}
