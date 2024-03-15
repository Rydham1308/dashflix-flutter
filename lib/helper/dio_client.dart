import 'package:dio/dio.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    const baseUrl = 'https://api.themoviedb.org/3/';

    final BaseOptions options = BaseOptions(
      sendTimeout: const Duration(seconds: 60),
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      baseUrl: baseUrl,
      queryParameters: {
        "api_key": "6ba01d99513c2ddb896bd4291711fd10",
      },
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
      },
    );

    _dio = Dio(options);
  }

  Dio getDio() => _dio;
}
