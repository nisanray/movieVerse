import 'package:get/get.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';

/// [MovieDiscoveryController] handles the state and data fetching for the Discovery (Home) screen.
/// It uses GetX StateMixin for efficient UI updates (Loading, Success, Error states).
class MovieDiscoveryController extends GetxController with StateMixin<List<Movie>> {
  final MovieRepository _repository;

  MovieDiscoveryController(this._repository);

  // Observable lists for different movie categories to enable granular UI updates.
  final RxList<Movie> trendingMovies = <Movie>[].obs;
  final RxList<Movie> popularMovies = <Movie>[].obs;
  final RxList<Movie> nowPlayingMovies = <Movie>[].obs;
  
  // High-level loading state for the initial page load.
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Fetch all required data immediately when the controller is created.
    fetchAllMovies();
  }

  /// Fetches Trending, Popular, and Now Playing movies from the repository.
  /// Requests are executed in parallel via [Future.wait] to minimize load time.
  Future<void> fetchAllMovies() async {
    try {
      isLoading.value = true;
      
      final results = await Future.wait([
        _repository.getTrendingMovies(),
        _repository.getPopularMovies(),
        _repository.getNowPlayingMovies(),
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
