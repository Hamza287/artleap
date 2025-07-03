import 'package:dio/dio.dart';

class DioCore {
  late Dio _dio;
  Dio get dio => _dio;

  DioCore(String baseUrl) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      validateStatus: (status) => true,
      connectTimeout: const Duration(minutes: 3),
      sendTimeout: const Duration(minutes: 3),
      receiveTimeout: const Duration(minutes: 3),
    ));
    // Add interceptors if needed
    _dio.interceptors.add(LogInterceptor(
      request: true,
      responseBody: true,
      requestBody: true,
    ));
  }
}