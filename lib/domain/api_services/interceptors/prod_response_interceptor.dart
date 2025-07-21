import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:Artleap.ai/shared/app_persistance/app_local.dart';
import '../../../shared/constants/app_constants.dart';

class ProdResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.extra[localDataStorageEnabled]) {
      AppLocal.ins.dataBox
          .put(response.requestOptions.path, jsonEncode(response.data));
    }
    super.onResponse(response, handler);
  }
}
