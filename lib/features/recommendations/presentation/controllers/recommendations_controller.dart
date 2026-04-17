import 'package:get/get.dart';
import '../../domain/repositories/recommendations_repository.dart';
import '../../../media_discovery/domain/entities/media.dart';
import '../../../watchlist/presentation/controllers/watchlist_controller.dart';
import '../../../ratings/domain/repositories/rating_repository.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class RecommendationsController extends GetxController with StateMixin<Map<String, List<Media>>> {
  final RecommendationsRepository _repository;
  final RatingRepository _ratingRepository;
  final WatchlistController _watchlistController = Get.find<WatchlistController>();
  final AuthController _authController = Get.find<AuthController>();

  RecommendationsController(this._repository, this._ratingRepository);

  // Suggested by preference
  final RxList<Media> genreRecommendations = <Media>[].obs;
  // Suggested based on specific media
  final RxList<Media> basedOnMediaRecs = <Media>[].obs;
  final RxString baseMediaTitle = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Reactively refresh when watchlist changes
    ever(_watchlistController.watchlistIds, (_) => fetchRecommendations());
    fetchRecommendations();
  }

  Future<void> fetchRecommendations() async {
    final watchlist = _watchlistController.state ?? [];
    final user = _authController.user.value;
    
    // We need at least something to recommend from
    if (watchlist.isEmpty && user == null) {
      change({}, status: RxStatus.empty());
      return;
    }

    try {
      change(null, status: RxStatus.loading());

      // 1. Fetch User Ratings for Weighted Preferences
      final ratings = user != null 
          ? await _ratingRepository.getAllUserRatings(user.uid)
          : [];

      // 2. Calculate Weighted Genre Scores
      final Map<int, double> genreScores = {};
      final Set<int> seenMediaIds = {};

      // Watchlist Influence (Base interest)
      for (var media in watchlist) {
        seenMediaIds.add(media.id);
        for (var genreId in media.genreIds) {
          genreScores[genreId] = (genreScores[genreId] ?? 0) + 1.0;
        }
      }

      // Ratings Influence (Strong Signal)
      for (var rating in ratings) {
        seenMediaIds.add(rating.mediaId);
        
        double weight = 0;
        if (rating.rating >= 4.0) {
          weight = 3.0; // Loved it!
        } else if (rating.rating <= 2.5) {
          weight = -2.0; // Didn't like it much.
        }

        if (weight != 0) {
          for (var genreId in rating.genreIds) {
            genreScores[genreId] = (genreScores[genreId] ?? 0) + weight;
          }
        }
      }

      // Sort and take top 3 genres
      final sortedGenres = genreScores.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      
      final topGenres = sortedGenres
          .where((e) => e.value > 0) // Only positive interests
          .take(3)
          .map((e) => e.key)
          .toList();

      // 3. Fetch Recommendations
      List<Media> genreRecs = [];
      if (topGenres.isNotEmpty) {
        genreRecs = await _repository.getRecommendationsByGenres(topGenres, 'movie');
      }

      // 4. Fetch Similar Content based on the best signal
      // Priority: Highest Rated Recent Movie > Last Watchlist Item
      final bestRatedRecent = ratings.firstWhereOrNull((r) => r.rating >= 4.0);
      
      int? baseMediaId;
      String baseMediaType = 'movie';

      if (bestRatedRecent != null) {
        baseMediaId = bestRatedRecent.mediaId;
        baseMediaType = bestRatedRecent.mediaType;
        baseMediaTitle.value = "Highly Rated Picks"; // Optional: could fetch title
      } else if (watchlist.isNotEmpty) {
        final lastMedia = watchlist.last;
        baseMediaId = lastMedia.id;
        baseMediaType = lastMedia.isMovie ? 'movie' : 'tv';
        baseMediaTitle.value = lastMedia.title;
      }

      List<Media> mediaRecs = [];
      if (baseMediaId != null) {
        mediaRecs = await _repository.getRecommendationsByMedia(baseMediaId, baseMediaType);
      }

      // 5. Filter out SEEN content (Watchlisted or Rated)
      final filteredGenreRecs = genreRecs
          .where((m) => !seenMediaIds.contains(m.id))
          .toList();
      
      final filteredMediaRecs = mediaRecs
          .where((m) => !seenMediaIds.contains(m.id))
          .toList();

      final result = {
        'personalized': filteredGenreRecs,
        'similar': filteredMediaRecs,
      };

      change(result, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }
}
