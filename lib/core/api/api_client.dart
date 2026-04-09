import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// [ApiClient] is a centralized service for handling all HTTP communication.
/// It uses the Dio package and integrates with GetX for dependency management.
class ApiClient extends getx.GetxService {
  late Dio dio;
  final String baseUrl = 'https://api.themoviedb.org/3';
  
  /// The TMDB API key is securely retrieved from the .env file.
  final String apiKey = dotenv.env['TMDB_API_KEY'] ?? ''; 

  /// Initializes the Dio client with base configurations and interceptors.
  Future<ApiClient> init() async {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        // Inject API Key into every request by default via Query Parameters
        queryParameters: {
          'api_key': apiKey,
        },
      ),
    );

    /// Logging interceptor helps in debugging API requests and responses in development.
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));

    return this;
  }

  /// [getData] is a generic wrapper for GET requests to simplify API calls across the app.
  Future<Response> getData(String uri) async {
    try {
      return await dio.get(uri);
    } catch (e) {
      // Re-throw the error to be handled by the calling Controller
      return Response(
        requestOptions: RequestOptions(path: uri),
        statusCode: 1,
        statusMessage: e.toString(),
      );
    }
  }
}
