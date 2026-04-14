import '../../domain/entities/media.dart';
import '../../domain/entities/genre.dart';
import '../../domain/repositories/media_repository.dart';
import '../datasources/media_remote_data_source.dart';

class MediaRepositoryImpl implements MediaRepository {
  final MediaRemoteDataSource remoteDataSource;

  MediaRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Media>> getTrendingMovies() async {
    return await remoteDataSource.getTrendingMovies();
  }

  @override
  Future<List<Media>> getPopularMovies() async {
    return await remoteDataSource.getPopularMovies();
  }

  @override
  Future<List<Media>> getNowPlayingMovies() async {
    return await remoteDataSource.getNowPlayingMovies();
  }

  @override
  Future<List<Media>> getTrendingTv() async {
    return await remoteDataSource.getTrendingTv();
  }

  @override
  Future<List<Media>> getPopularTv() async {
    return await remoteDataSource.getPopularTv();
  }

  @override
  Future<List<Media>> getNowPlayingTv() async {
    return await remoteDataSource.getNowPlayingTv();
  }

  @override
  Future<List<Media>> searchMedia(String query) async {
    return await remoteDataSource.searchMedia(query);
  }

  @override
  Future<List<Genre>> getGenres(String type) async {
    return await remoteDataSource.getGenres(type);
  }

  @override
  Future<Map<String, String>> getCountries() async {
    return await remoteDataSource.getCountries();
  }

  @override
  Future<List<Media>> discoverMedia({
    required String type,
    int? genreId,
    int? year,
    String? countryCode,
    String? sortBy,
  }) async {
    return await remoteDataSource.discoverMedia(
      type: type,
      genreId: genreId,
      year: year,
      countryCode: countryCode,
      sortBy: sortBy,
    );
  }
}
