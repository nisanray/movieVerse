import 'package:get/get.dart';
import '../../domain/entities/media.dart';
import '../../domain/repositories/movie_repository.dart';

/// [MovieDiscoveryController] handles the state and data fetching for the Discovery (Home) screen.
/// It uses GetX StateMixin for efficient UI updates (Loading, Success, Error states).
class MovieDiscoveryController extends GetxController with StateMixin<List<Media>> {
  final MovieRepository _repository;

  MovieDiscoveryController(this._repository);

  // Observable for current media type (movie or tv).
  final RxString selectedMediaType = 'movie'.obs;

  // Observable lists for different media categories to enable granular UI updates.
  final RxList<Media> trendingMovies = <Media>[].obs;
  final RxList<Media> popularMovies = <Media>[].obs;
  final RxList<Media> nowPlayingMovies = <Media>[].obs;
  
  // High-level loading state for the initial page load.
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Fetch all required data immediately when the controller is created.
    fetchAllMedia();
  }

  /// Toggles between 'movie' and 'tv' and refreshes the feed.
  void toggleMediaType(String type) {
    if (selectedMediaType.value == type) return;
    selectedMediaType.value = type;
    fetchAllMedia();
  }

  /// Fetches Trending, Popular, and Now Playing media from the repository.
  /// Requests are executed in parallel via [Future.wait] to minimize load time.
  Future<void> fetchAllMedia() async {
    try {
      isLoading.value = true;
      
      final bool isMovieSelected = selectedMediaType.value == 'movie';
      
      final results = await Future.wait([
        isMovieSelected 
            ? _repository.getTrendingMovies() 
            : _repository.getTrendingTv(),
        isMovieSelected
            ? _repository.getPopularMovies()
            : _repository.getPopularTv(),
        isMovieSelected
            ? _repository.getNowPlayingMovies()
            : _repository.getNowPlayingTv(),
      ]);

      // Assign fetched data to the observable lists.
      trendingMovies.assignAll(results[0]);
      popularMovies.assignAll(results[1]);
      nowPlayingMovies.assignAll(results[2]);
      
      // Update global state to success.
      change(results[0], status: RxStatus.success());
    } catch (e) {
      // Transition to error state if any of the requests fail.
      change(null, status: RxStatus.error(e.toString()));
    } finally {
      isLoading.value = false;
    }
  }
}
