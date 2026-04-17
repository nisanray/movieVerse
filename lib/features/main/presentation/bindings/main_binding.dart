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
import '../../../watchlist/data/repositories/watchlist_repository_impl.dart';
import '../../../watchlist/domain/repositories/watchlist_repository.dart';
import '../../../watchlist/presentation/controllers/watchlist_controller.dart';
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

    // Watchlist (Global)
    if (!Get.isRegistered<WatchlistRepository>()) {
      Get.lazyPut<WatchlistRepository>(
        () => WatchlistRepositoryImpl(),
        fenix: true,
      );
    }
    if (!Get.isRegistered<WatchlistController>()) {
      Get.lazyPut(
        () => WatchlistController(Get.find<WatchlistRepository>()),
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
