import '../entities/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> getTrendingMovies();
  Future<List<Movie>> getPopularMovies();
  Future<List<Movie>> getNowPlayingMovies();
}
