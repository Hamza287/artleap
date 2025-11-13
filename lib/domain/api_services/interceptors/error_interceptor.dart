import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:Artleap.ai/shared/app_persistance/app_local.dart';
import '../../../shared/constants/app_constants.dart';
import '../../../shared/utilities/general_methods.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.requestOptions.extra[localDataStorageEnabled]) {
      var data = AppLocal.ins.dataBox.get(err.requestOptions.path);
      if (isNotNull(data)) {
        handler.resolve(Response(
            requestOptions: RequestOptions(),
            data: jsonDecode(data),
            statusCode: 200));
      } else {
        super.onError(err, handler);
      }
    } else {
      super.onError(err, handler);
    }
  }
}
