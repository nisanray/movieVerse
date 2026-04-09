import '../../../../core/api/api_client.dart';
import '../models/movie_details_model.dart';
import '../models/movie_details_submodels.dart';

/// Abstract contract for fetching detailed movie information from the TMDB API.
/// Implementations should handle network calls and data transformation.
abstract class MovieDetailsRemoteDataSource {
  /// Retrieves a complete [MovieDetailsModel] for the given [movieId].
  /// The implementation typically fetches details, credits, and videos in parallel.
  Future<MovieDetailsModel> getMovieDetails(int movieId);
}

/// Concrete implementation using the shared [ApiClient] service.
class MovieDetailsRemoteDataSourceImpl implements MovieDetailsRemoteDataSource {
  final ApiClient apiClient;

  MovieDetailsRemoteDataSourceImpl({required this.apiClient});

  @override
  /// Fetches movie details, cast, and video information concurrently.
  /// Returns a fully populated [MovieDetailsModel] ready for domain mapping.
  Future<MovieDetailsModel> getMovieDetails(int movieId) async {
    // Fetch Movie Details, Credits, and Videos in parallel
    final results = await Future.wait([
      apiClient.getData('/movie/$movieId'),
      apiClient.getData('/movie/$movieId/credits'),
      apiClient.getData('/movie/$movieId/videos'),
    ]);

    final movieJson = results[0].data;
    final castJson = results[1].data['cast'] as List;
    final videoJson = results[2].data['results'] as List;

    final cast = castJson.map((c) => CastModel.fromJson(c)).toList();
    final videos = videoJson.map((v) => VideoModel.fromJson(v)).toList();

    return MovieDetailsModel.fromJson(
      movieJson,
      cast: cast,
      videos: videos,
    );
  }
}
