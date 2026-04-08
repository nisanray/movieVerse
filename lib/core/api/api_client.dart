import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;

class ApiClient extends getx.GetxService {
  late Dio dio;
  final String baseUrl = 'https://api.themoviedb.org/3';
  
  // Placeholder: Always use environment variables or secrets in production
  final String apiKey = 'YOUR_TMDB_API_KEY';

  Future<ApiClient> init() async {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        queryParameters: {
          'api_key': apiKey,
        },
      ),
    );

    // Add interceptors here (logging, auth, etc.)
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));

    return this;
  }

  Future<Response> getData(String path, {Map<String, dynamic>? query}) async {
    try {
      return await dio.get(path, queryParameters: query);
    } catch (e) {
      rethrow;
    }
  }
}
