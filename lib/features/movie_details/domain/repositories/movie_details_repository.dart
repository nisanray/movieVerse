import '../entities/movie_details_entities.dart';

abstract class MovieDetailsRepository {
  Future<MovieDetails> getMovieDetails(int movieId);
}
