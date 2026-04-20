import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../models/media_model.dart';
import '../../domain/entities/genre.dart';

abstract class MediaRemoteDataSource {
  Future<List<MediaModel>> getTrendingMovies();
  Future<List<MediaModel>> getPopularMovies();
  Future<List<MediaModel>> getNowPlayingMovies();
  Future<List<MediaModel>> getTrendingTv();
  Future<List<MediaModel>> getPopularTv();
  Future<List<MediaModel>> getNowPlayingTv();
  Future<List<MediaModel>> searchMedia(String query);
  Future<List<Genre>> getGenres(String type); // movie or tv
  Future<Map<String, String>> getCountries();
  Future<List<MediaModel>> discoverMedia({
    required String type,
    int? genreId,
    int? year,
    String? countryCode,
    String? sortBy,
  });
  Future<MediaModel?> getMediaDetails(int mediaId, String mediaType);
}

class MediaRemoteDataSourceImpl implements MediaRemoteDataSource {
  final ApiClient apiClient;

  MediaRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<MediaModel>> getTrendingMovies() async {
    final response = await apiClient.getData('/trending/movie/day');
    return _parseMedia(response);
  }

  @override
  Future<List<MediaModel>> getPopularMovies() async {
    final response = await apiClient.getData('/movie/popular');
    return _parseMedia(response);
  }

  @override
  Future<List<MediaModel>> getNowPlayingMovies() async {
    final response = await apiClient.getData('/movie/now_playing');
    return _parseMedia(response);
  }

  @override
  Future<List<MediaModel>> getTrendingTv() async {
    final response = await apiClient.getData('/trending/tv/day');
    return _parseMedia(response);
  }

  @override
  Future<List<MediaModel>> getPopularTv() async {
    final response = await apiClient.getData('/tv/popular');
    return _parseMedia(response);
  }

  @override
  Future<List<MediaModel>> getNowPlayingTv() async {
    final response = await apiClient.getData('/tv/on_the_air');
    return _parseMedia(response);
  }

  @override
  Future<List<MediaModel>> searchMedia(String query) async {
    final response = await apiClient.getData(
      '/search/multi',
      queryParameters: {'query': query},
    );
    return _parseMedia(response);
  }

  @override
  Future<List<Genre>> getGenres(String type) async {
    final response = await apiClient.getData('/genre/$type/list');
    if (response.data != null && response.data['genres'] != null) {
      final List results = response.data['genres'];
      return results.map((json) => Genre.fromJson(json)).toList();
    }
    return [];
  }

  @override
  Future<Map<String, String>> getCountries() async {
    final response = await apiClient.getData('/configuration/countries');
    if (response.data != null && response.data is List) {
      final List results = response.data;
      // Maps ISO code to English Name
      return {
        for (var item in results) item['iso_3166_1']: item['english_name'],
      };
    }
    return {};
  }

  @override
  Future<List<MediaModel>> discoverMedia({
    required String type,
    int? genreId,
    int? year,
    String? countryCode,
    String? sortBy,
  }) async {
    final Map<String, dynamic> params = {
      'sort_by': sortBy ?? 'popularity.desc',
      if (genreId != null) 'with_genres': genreId.toString(),
      if (countryCode != null) 'with_origin_country': countryCode,
      if (year != null)
        type == 'movie' ? 'primary_release_year' : 'first_air_date_year': year
            .toString(),
    };

    final response = await apiClient.getData(
      '/discover/$type',
      queryParameters: params,
    );
    return _parseMedia(response);
  }

  List<MediaModel> _parseMedia(Response response) {
    if (response.data != null && response.data['results'] != null) {
      final List results = response.data['results'];
      return results.map((json) => MediaModel.fromJson(json)).toList();
    }
    return [];
  }

  @override
  Future<MediaModel?> getMediaDetails(int mediaId, String mediaType) async {
    final response = await apiClient.getData('/$mediaType/$mediaId');
    if (response.data != null) {
      return MediaModel.fromJson(response.data);
    }
    return null;
  }
}
