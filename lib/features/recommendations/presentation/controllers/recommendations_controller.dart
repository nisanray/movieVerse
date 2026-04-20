import 'package:get/get.dart';
import '../../domain/repositories/recommendations_repository.dart';
import '../../domain/usecases/calculate_recommendations_usecase.dart';
import '../../domain/usecases/match_percentage_calculator.dart';
import '../../../media_discovery/domain/entities/media.dart';
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

  RecommendationsController(this._repository, this._ratingRepository);

  // Suggested by preference
  final RxList<Media> genreRecommendations = <Media>[].obs;
  // Suggested based on specific media
  final RxList<Media> basedOnMediaRecs = <Media>[].obs;
  final RxString baseMediaTitle = ''.obs;

  // Personal Taste Profile for Match % calculations
  final RxMap<int, double> genreScores = <int, double>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // Reactively refresh when watch later or watched lists change
    ever(_watchLaterController.watchLaterIds, (_) => fetchRecommendations());
    ever(_watchedController.watchedIds, (_) => fetchRecommendations());
    fetchRecommendations();
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

    // We need at least something to recommend from
    if (watchLaterList.isEmpty && watchedList.isEmpty && user == null) {
      change({}, status: RxStatus.empty());
      return;
    }

    try {
      change(null, status: RxStatus.loading());

      // 1. Fetch User Ratings for Weighted Preferences
      final ratings = user != null
          ? await _ratingRepository.getAllUserRatings(user.uid)
          : [];

      // 2. Calculate Weighted Genre Scores using use case
      final tempScores = _calculateRecommendationsUseCase.calculateGenreScores(
        watchLaterList: watchLaterList,
        watchedList: watchedList,
        ratings: ratings.cast<RatingEntity>(),
      );

      // Store in observable map for Match % calculations
      genreScores.assignAll(tempScores);

      // Get top genres using use case
      final topGenres = _calculateRecommendationsUseCase.getTopGenres(
        tempScores,
      );

      // 3. Fetch Recommendations
      List<Media> genreRecs = [];
      if (topGenres.isNotEmpty) {
        genreRecs = await _repository.getRecommendationsByGenres(
          topGenres,
          'movie',
        );
      }

      // 4. Fetch Similar Content based on the best signal using use case
      final baseMedia = _calculateRecommendationsUseCase.determineBestBaseMedia(
        watchLaterList: watchLaterList,
        watchedList: watchedList,
        ratings: ratings.cast<RatingEntity>(),
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

      change({
        'personalized': genreRecs,
        'similar': mediaRecs,
      }, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }
}
