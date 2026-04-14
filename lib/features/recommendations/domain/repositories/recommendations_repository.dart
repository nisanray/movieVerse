import '../../../media_discovery/domain/entities/media.dart';

abstract class RecommendationsRepository {
  /// Fetches media based on a list of genre IDs.
  Future<List<Media>> getRecommendationsByGenres(List<int> genreIds, String type);

  /// Fetches media similar/recommended for a specific media ID.
  Future<List<Media>> getRecommendationsByMedia(int mediaId, String type);
}
