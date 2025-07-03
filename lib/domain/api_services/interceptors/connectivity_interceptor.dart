import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import '../../../shared/constants/app_constants.dart';

class ConnectivityInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none) &&
        !options.extra[localDataStorageEnabled]) {
      handler.reject(DioException(
        requestOptions: options,
        error: 'No Internet Connection',
        type: DioExceptionType.connectionError,
      ));
    } else {
      handler.next(options);
    }
  }
}
