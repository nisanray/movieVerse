import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../models/movie_model.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getTrendingMovies();
  Future<List<MovieModel>> getPopularMovies();
  Future<List<MovieModel>> getNowPlayingMovies();
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final ApiClient apiClient;

  MovieRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<MovieModel>> getTrendingMovies() async {
    final response = await apiClient.getData('/trending/movie/day');
    return _parseMovies(response);
  }

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    final response = await apiClient.getData('/movie/popular');
    return _parseMovies(response);
  }

  @override
  Future<List<MovieModel>> getNowPlayingMovies() async {
    final response = await apiClient.getData('/movie/now_playing');
    return _parseMovies(response);
  }

  List<MovieModel> _parseMovies(Response response) {
    if (response.data != null && response.data['results'] != null) {
      final List results = response.data['results'];
      return results.map((json) => MovieModel.fromJson(json)).toList();
    }
    return [];
  }
}
