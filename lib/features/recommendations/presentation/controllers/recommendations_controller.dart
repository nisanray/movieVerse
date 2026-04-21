import 'dart:async';
import 'package:get/get.dart';
import '../../domain/repositories/recommendations_repository.dart';
import '../../domain/usecases/calculate_recommendations_usecase.dart';
import '../../domain/usecases/match_percentage_calculator.dart';
import '../../../../core/domain/entities/media.dart';
import '../../../watch_later/presentation/controllers/watch_later_controller.dart';
import '../../../watched/presentation/controllers/watched_controller.dart';
import '../../../ratings/domain/repositories/rating_repository.dart';
import '../../../ratings/domain/entities/rating_entity.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class RecommendationsController extends GetxController
    with StateMixin<Map<String, List<Media>>> {
  final RecommendationsRepository _repository;
  final RatingRepository _ratingRepository;
  
  final WatchLaterController _watchLaterController =
      Get.find<WatchLaterController>();
  final WatchedController _watchedController = Get.find<WatchedController>();
  final AuthController _authController = Get.find<AuthController>();
  
  final CalculateRecommendationsUseCase _calculateRecommendationsUseCase =
      CalculateRecommendationsUseCase();
  final MatchPercentageCalculator _matchPercentageCalculator =
      MatchPercentageCalculator();

  StreamSubscription? _ratingsSubscription;

  RecommendationsController(this._repository, this._ratingRepository);

  // Suggested by preference
  final RxList<Media> genreRecommendations = <Media>[].obs;
  // Suggested based on specific media
  final RxList<Media> basedOnMediaRecs = <Media>[].obs;
  final RxString baseMediaTitle = ''.obs;

  // Personal Taste Profile for Match % calculations
  final RxMap<int, double> genreScores = <int, double>{}.obs;

  // Track if current results are personalized or fallback trendings
  final RxBool isPersonalized = false.obs;

  @override
  void onInit() {
    super.onInit();
    
    // 1. Sync with Auth State (Fixes race condition on app opening)
    ever(_authController.user, (user) {
      if (user != null) {
        _listenToRatings(user.uid);
      } else {
        _ratingsSubscription?.cancel();
        fetchRecommendations();
      }
    });

    // 2. Sync with Watchlist & History
    ever(_watchLaterController.watchLaterIds, (_) => fetchRecommendations());
    ever(_watchedController.watchedIds, (_) => fetchRecommendations());
    
    // Initial setup based on current auth state
    if (_authController.user.value != null) {
      _listenToRatings(_authController.user.value!.uid);
    } else {
      fetchRecommendations();
    }
  }

  /// Sets up real-time observation of user ratings
  void _listenToRatings(String uid) {
    _ratingsSubscription?.cancel();
    _ratingsSubscription = _ratingRepository.watchAllUserRatings(uid).listen((_) {
      fetchRecommendations();
    });
  }

  /// Calculates a personalized match percentage (0-100) for a given media item.
  int getMatchPercentage(Media media) {
    return _matchPercentageCalculator.calculateMatchPercentage(
      media,
      genreScores,
    );
  }

  Future<void> fetchRecommendations() async {
    final watchLaterList = _watchLaterController.state ?? [];
    final watchedList = _watchedController.state ?? [];
    final user = _authController.user.value;

    try {
      change(null, status: RxStatus.loading());

      // 1. Fetch User Ratings for Weighted Preferences
      final ratings = user != null
          ? await _ratingRepository.getAllUserRatings(user.uid)
          : <RatingEntity>[];

      // 2. Calculate Weighted Genre Scores
      final tempScores = _calculateRecommendationsUseCase.calculateGenreScores(
        watchLaterList: watchLaterList,
        watchedList: watchedList,
        ratings: ratings,
      );

      // Store in observable map for Match % calculations
      genreScores.assignAll(tempScores);
      
      // Determine if we have enough data for personalization
      isPersonalized.value = tempScores.values.any((score) => score > 0);

      // Get top genres (with robust fallback logic in the use case)
      final topGenres = _calculateRecommendationsUseCase.getTopGenres(
        tempScores,
      );

      // 3. Fetch Recommendations
      List<Media> genreRecs = await _repository.getRecommendationsByGenres(
        topGenres,
        'movie',
      );

      // 4. Fetch Similar Content
      final baseMedia = _calculateRecommendationsUseCase.determineBestBaseMedia(
        watchLaterList: watchLaterList,
        watchedList: watchedList,
        ratings: ratings,
      );

      baseMediaTitle.value = baseMedia.title;

      List<Media> mediaRecs = [];
      if (baseMedia.mediaId != null) {
        mediaRecs = await _repository.getRecommendationsByMedia(
          baseMedia.mediaId!,
          baseMedia.mediaType,
        );
      }

      genreRecommendations.assignAll(genreRecs);
      basedOnMediaRecs.assignAll(mediaRecs);

      if (genreRecs.isEmpty && mediaRecs.isEmpty) {
        change({}, status: RxStatus.empty());
      } else {
        change({
          'personalized': genreRecs,
          'similar': mediaRecs,
        }, status: RxStatus.success());
      }
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  @override
  void onClose() {
    _ratingsSubscription?.cancel();
    super.onClose();
  }
}

