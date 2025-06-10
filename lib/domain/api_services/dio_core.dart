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
    // _dio.interceptors.add(PrettyDioLogger());
    // _dio.interceptors.add(ConnectivityInterceptor());
    // _dio.interceptors.add(RequestInterceptor());
    // _dio.interceptors.add(ErrorInterceptor());

    // // _dio.interceptors.add(RetryInterceptor());
    // if (AppConstants.responseMode == ResponseMode.mock) {
    //   _dio.interceptors.add(MockInterceptor());
    // } else if (AppConstants.responseMode == ResponseMode.real) {
    //   _dio.interceptors.add(ProdResponseInterceptor());
    // }
  }
}
