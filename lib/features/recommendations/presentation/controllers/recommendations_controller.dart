import 'package:get/get.dart';
import '../../domain/repositories/recommendations_repository.dart';
import '../../../media_discovery/domain/entities/media.dart';
import '../../../watchlist/presentation/controllers/watchlist_controller.dart';

class RecommendationsController extends GetxController with StateMixin<Map<String, List<Media>>> {
  final RecommendationsRepository _repository;
  final WatchlistController _watchlistController = Get.find<WatchlistController>();

  RecommendationsController(this._repository);

  // Suggested by genres
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
    final watchlist = _watchlistController.state;
    
    if (watchlist == null || watchlist.isEmpty) {
      change({}, status: RxStatus.empty());
      return;
    }

    try {
      change(null, status: RxStatus.loading());

      // 1. Calculate top genres
      final Map<int, int> genreCounts = {};
      for (var media in watchlist) {
        for (var genreId in media.genreIds) {
          genreCounts[genreId] = (genreCounts[genreId] ?? 0) + 1;
        }
      }

      final sortedGenres = genreCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      
      final topGenres = sortedGenres.take(3).map((e) => e.key).toList();

      // 2. Fetch recommendations by top genres
      final List<Media> genreRecs = [];
      if (topGenres.isNotEmpty) {
        genreRecs.addAll(await _repository.getRecommendationsByGenres(topGenres, 'movie'));
      }

      // 3. Fetch recommendations based on the most recent watchlist item
      final lastMedia = watchlist.last;
      baseMediaTitle.value = lastMedia.title;
      final mediaRecs = await _repository.getRecommendationsByMedia(
        lastMedia.id, 
        lastMedia.isMovie ? 'movie' : 'tv'
      );

      final result = {
        'personalized': genreRecs,
        'similar': mediaRecs,
      };

      change(result, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }
}
