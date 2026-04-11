import '../entities/media.dart';
import '../entities/genre.dart';

abstract class MovieRepository {
  Future<List<Media>> getTrendingMovies();
  Future<List<Media>> getPopularMovies();
  Future<List<Media>> getNowPlayingMovies();
  Future<List<Media>> getTrendingTv();
  Future<List<Media>> getPopularTv();
  Future<List<Media>> getNowPlayingTv();
  Future<List<Media>> searchMedia(String query);
  Future<List<Genre>> getGenres(String type);
  Future<Map<String, String>> getCountries();
  Future<List<Media>> discoverMedia({
    required String type,
    int? genreId,
    int? year,
    String? countryCode,
    String? sortBy,
  });
}
