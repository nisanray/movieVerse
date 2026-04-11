import 'package:flutter/material.dart';
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

  // Search and Genre States
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final RxString searchQuery = ''.obs;
  final RxList<String> genres = <String>[].obs;
  final RxString selectedGenre = 'All'.obs;

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
    fetchGenres();
    
    // Listen to search changes with debounce
    debounce(searchQuery, (query) {
      if (query.isNotEmpty) {
        performSearch(query);
      } else {
        fetchAllMedia();
      }
    }, time: const Duration(milliseconds: 500));
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }

  /// Toggles between 'movie' and 'tv' and refreshes the feed.
  void toggleMediaType(String type) {
    if (selectedMediaType.value == type) return;
    selectedMediaType.value = type;
    selectedGenre.value = 'All'; // Reset genre on type change
    fetchAllMedia();
    fetchGenres();
  }

  /// Fetches Genres for the current media type.
  Future<void> fetchGenres() async {
    try {
      final fetchedGenres = await _repository.getGenres(selectedMediaType.value);
      genres.assignAll(['All', ...fetchedGenres]);
    } catch (e) {
      genres.assignAll(['All']);
    }
  }

  /// Updates the selected genre and filters the feed.
  void selectGenre(String genre) {
    selectedGenre.value = genre;
    // TODO: Implement discoverMedia with genre filter
  }

  /// Performs a search for both Movies and TV Shows.
  Future<void> performSearch(String query) async {
    try {
      isLoading.value = true;
      final results = await _repository.searchMedia(query);
      change(results, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    } finally {
      isLoading.value = false;
    }
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
