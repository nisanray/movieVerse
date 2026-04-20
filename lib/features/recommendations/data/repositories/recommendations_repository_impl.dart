import '../../../../core/api/api_client.dart';
import '../../../../core/data/models/media_model.dart';
import '../../../../core/domain/entities/media.dart';
import '../../domain/repositories/recommendations_repository.dart';

class RecommendationsRepositoryImpl implements RecommendationsRepository {
  final ApiClient _apiClient;

  RecommendationsRepositoryImpl(this._apiClient);

  @override
  Future<List<Media>> getRecommendationsByGenres(List<int> genreIds, String type) async {
    try {
      final response = await _apiClient.getData(
        '/discover/$type',
        queryParameters: {
          'with_genres': genreIds.join(','),
          'sort_by': 'popularity.desc',
        },
      );

      final List results = response.data['results'];
      return results.map((json) => MediaModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Media>> getRecommendationsByMedia(int mediaId, String type) async {
    try {
      final response = await _apiClient.getData('/$type/$mediaId/recommendations');
      final List results = response.data['results'];
      return results.map((json) => MediaModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}

