import '../../../movie_discovery/domain/entities/media.dart';
import '../../domain/entities/movie_details_entities.dart';
import '../../domain/repositories/movie_details_repository.dart';
import '../datasources/movie_details_remote_data_source.dart';

class MovieDetailsRepositoryImpl implements MovieDetailsRepository {
  final MovieDetailsRemoteDataSource remoteDataSource;

  MovieDetailsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<MovieDetails> getMovieDetails(int id, String type) async {
    return await remoteDataSource.getMovieDetails(id, type);
  }

  @override
  Future<List<Media>> getSimilarMedia(int id, String type) async {
    return await remoteDataSource.getSimilarMedia(id, type);
  }
}
