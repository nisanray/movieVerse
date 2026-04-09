import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_remote_data_source.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;

  MovieRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Movie>> getTrendingMovies() async {
    return await remoteDataSource.getTrendingMovies();
  }

  @override
  Future<List<Movie>> getPopularMovies() async {
    return await remoteDataSource.getPopularMovies();
  }

  @override
  Future<List<Movie>> getNowPlayingMovies() async {
    return await remoteDataSource.getNowPlayingMovies();
  }
}
