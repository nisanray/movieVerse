import '../../../movie_discovery/domain/entities/media.dart';
import '../entities/movie_details_entities.dart';

abstract class MovieDetailsRepository {
  Future<MovieDetails> getMovieDetails(int id, String type);
  Future<List<Media>> getSimilarMedia(int id, String type);
}
