import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/entities/media.dart';
import '../../domain/entities/genre.dart';
import '../../domain/repositories/movie_repository.dart';

/// [MovieDiscoveryController] handles the state and data fetching for the Discovery (Home) screen.
/// It uses GetX StateMixin for efficient UI updates (Loading, Success, Error states).
class MovieDiscoveryController extends GetxController with StateMixin<List<Media>> {
  final MovieRepository _repository;
  final AuthController authController = Get.find<AuthController>();

  MovieDiscoveryController(this._repository);

  // Observable for current media type (movie or tv).
  final RxString selectedMediaType = 'movie'.obs;

  // Search, Genre, and Year States
  final RxString selectedSortBy = 'popularity.desc'.obs;
  final RxMap<String, String> countries = <String, String>{}.obs;

  // Search, Genre, and Year States
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final RxString searchQuery = ''.obs;
  final RxList<Genre> genres = <Genre>[].obs;
  final Rx<Genre> selectedGenre = const Genre(id: 0, name: 'All').obs;
  final RxInt selectedYear = 0.obs;
  final RxString selectedCountryCode = ''.obs;
  
  // List of years from current year down to 1950.
  final List<int> availableYears = [
    0, // Representing "All"
    ...List.generate(DateTime.now().year - 1950 + 1, (index) => DateTime.now().year - index),
  ];

  // Observable lists for different media categories to enable granular UI updates.
  final RxList<Media> trendingMovies = <Media>[].obs;
  final RxList<Media> popularMovies = <Media>[].obs;
  final RxList<Media> nowPlayingMovies = <Media>[].obs;
  
  // High-level loading state for the initial page load.
  final RxBool isLoading = true.obs;

  // Scroll tracking for dynamic header
  final ScrollController scrollController = ScrollController();
  final RxBool isHeaderShrunk = false.obs;

  /// Returns true if any advanced filter (besides All) is applied.
  bool get hasActiveFilters => 
      selectedGenre.value.id != 0 || 
      selectedYear.value != 0 || 
      selectedCountryCode.value.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    // Fetch all required data immediately when the controller is created.
    fetchAllMedia();
    fetchGenres();
    fetchCountries();
    
    // Listen to scroll to shrink/expand header
    scrollController.addListener(_handleScroll);

    // Listen to search changes with debounce
    debounce(searchQuery, (query) {
      if (query.isNotEmpty) {
        performSearch(query);
      } else {
        fetchFilteredMedia();
      }
    }, time: const Duration(milliseconds: 500));
  }

  void _handleScroll() {
    if (scrollController.hasClients) {
      if (scrollController.offset > 50 && !isHeaderShrunk.value) {
        isHeaderShrunk.value = true;
      } else if (scrollController.offset <= 50 && isHeaderShrunk.value) {
        isHeaderShrunk.value = false;
      }
    }
  }

  @override
  void onClose() {
    // Note: We don't manually dispose searchController/focusNode here
    // because doing so during navigation transitions causes crashes.
    // Flutter's widget tree or GC will handle them safely.
    scrollController.dispose();
    super.onClose();
  }

  /// Toggles between 'movie' and 'tv' and refreshes the feed.
  void toggleMediaType(String type) {
    if (selectedMediaType.value == type) return;
    selectedMediaType.value = type;
    selectedGenre.value = const Genre(id: 0, name: 'All'); 
    selectedYear.value = 0;
    selectedCountryCode.value = '';
    fetchAllMedia();
    fetchGenres();
    fetchCountries();
  }

  /// Fetches Countries from the repository.
  Future<void> fetchCountries() async {
    try {
      final fetchedCountries = await _repository.getCountries();
      countries.assignAll(fetchedCountries);
    } catch (e) {
      countries.clear();
    }
  }

  /// Fetches Genres for the current media type.
  Future<void> fetchGenres() async {
    try {
      final fetchedGenres = await _repository.getGenres(selectedMediaType.value);
      genres.assignAll([const Genre(id: 0, name: 'All'), ...fetchedGenres]);
    } catch (e) {
      genres.assignAll([const Genre(id: 0, name: 'All')]);
    }
  }

  /// Updates the selected genre and filters the feed.
  void selectGenre(Genre genre) {
    selectedGenre.value = genre;
    fetchFilteredMedia();
  }

  /// Updates the selected year and filters the feed.
  void selectYear(int year) {
    selectedYear.value = year;
    fetchFilteredMedia();
  }

  /// Resets all filters to default.
  void resetFilters() {
    selectedGenre.value = const Genre(id: 0, name: 'All');
    selectedYear.value = 0;
    selectedCountryCode.value = '';
    selectedSortBy.value = 'popularity.desc';
    fetchFilteredMedia();
  }

  /// Fetches media based on the combination of current genre and year filters.
  Future<void> fetchFilteredMedia() async {
    if (!hasActiveFilters) {
      fetchAllMedia();
      return;
    }

    try {
      isLoading.value = true;
      final results = await _repository.discoverMedia(
        type: selectedMediaType.value,
        genreId: selectedGenre.value.id == 0 ? null : selectedGenre.value.id,
        year: selectedYear.value == 0 ? null : selectedYear.value,
        countryCode: selectedCountryCode.value.isEmpty ? null : selectedCountryCode.value,
        sortBy: selectedSortBy.value,
      );
      
      trendingMovies.assignAll(results);
      popularMovies.clear();
      nowPlayingMovies.clear();
      
      change(results, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    } finally {
      isLoading.value = false;
    }
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
