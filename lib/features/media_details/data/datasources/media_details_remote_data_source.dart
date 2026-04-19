import '../../../../core/api/api_client.dart';
import '../../../media_discovery/data/models/media_model.dart';
import '../models/media_details_model.dart';
import '../models/media_details_submodels.dart';

/// Abstract contract for fetching detailed media information from the TMDB API.
abstract class MediaDetailsRemoteDataSource {
  /// Retrieves a complete [MediaDetailsModel] for the given [id] and [type].
  Future<MediaDetailsModel> getMediaDetails(int id, String type);

  /// Retrieves a list of similar [MediaModel] entries.
  Future<List<MediaModel>> getSimilarMedia(int id, String type);
}

/// Concrete implementation using the shared [ApiClient] service.
class MediaDetailsRemoteDataSourceImpl implements MediaDetailsRemoteDataSource {
  final ApiClient apiClient;

  MediaDetailsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<MediaDetailsModel> getMediaDetails(int id, String type) async {
    final bool isMovie = type == 'movie';
    final String basePath = '/$type/$id';

    // Fetch Details, Credits, and Videos in parallel
    final results = await Future.wait([
      apiClient.getData(basePath),
      apiClient.getData('$basePath/credits'),
      apiClient.getData('$basePath/videos'),
    ]);

    final detailsJson = results[0].data;
    final castJson = results[1].data['cast'] as List;
    final videoJson = results[2].data['results'] as List;

    final cast = castJson.map((c) => CastModel.fromJson(c)).toList();
    final videos = videoJson.map((v) => VideoModel.fromJson(v)).toList();

    return MediaDetailsModel.fromJson(
      detailsJson,
      cast: cast,
      videos: videos,
      isMovie: isMovie,
    );
  }

  @override
  Future<List<MediaModel>> getSimilarMedia(int id, String type) async {
    final response = await apiClient.getData('/$type/$id/recommendations');
    
    if (response.data != null && response.data['results'] != null) {
      final List results = response.data['results'];
      return results.map((json) => MediaModel.fromJson(json)).toList();
    }
    return [];
  }
}
