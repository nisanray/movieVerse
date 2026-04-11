import '../../../../core/api/api_client.dart';
import '../../../movie_discovery/data/models/media_model.dart';
import '../models/movie_details_model.dart';
import '../models/movie_details_submodels.dart';

/// Abstract contract for fetching detailed media information from the TMDB API.
abstract class MovieDetailsRemoteDataSource {
  /// Retrieves a complete [MovieDetailsModel] for the given [id] and [type].
  Future<MovieDetailsModel> getMovieDetails(int id, String type);

  /// Retrieves a list of similar [MediaModel] entries.
  Future<List<MediaModel>> getSimilarMedia(int id, String type);
}

/// Concrete implementation using the shared [ApiClient] service.
class MovieDetailsRemoteDataSourceImpl implements MovieDetailsRemoteDataSource {
  final ApiClient apiClient;

  MovieDetailsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<MovieDetailsModel> getMovieDetails(int id, String type) async {
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

    return MovieDetailsModel.fromJson(
      detailsJson,
      cast: cast,
      videos: videos,
      isMovie: isMovie,
    );
  }

  @override
  Future<List<MediaModel>> getSimilarMedia(int id, String type) async {
    final response = await apiClient.getData('/$type/$id/similar');
    
    if (response.data != null && response.data['results'] != null) {
      final List results = response.data['results'];
      return results.map((json) => MediaModel.fromJson(json)).toList();
    }
    return [];
  }
}
