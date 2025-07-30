import 'package:dio/dio.dart';

import 'api_response.dart';

class HandlingResponse {
  static ApiResponse<T> returnResponse<T>(Response response, {T Function(dynamic)? fromJson}) {
    var data = response.data;

    // Fallback to handling based on HTTP status codes
    return switch (response.statusCode) {
      200 => ApiResponse<T>.completed(fromJson != null ? fromJson(data) : data),
      400 => ApiResponse<T>.error('Some Error Occurred'),
      401 => ApiResponse<T>.unAuthorised('Unauthorized'),
      403 => ApiResponse<T>.error('Forbidden'),
      404 => ApiResponse<T>.error('Not Found'),
      500 => ApiResponse<T>.error('Internal Server Error'),
      -6 => ApiResponse<T>.error('No Internet Connection'),
      _ => ApiResponse<T>.error('Unknown Error')
    };
  }

  static ApiResponse<T> returnException<T>(DioException exception) {
    return switch (exception.type) {
      DioExceptionType.connectionTimeout =>
      ApiResponse<T>.error('Connection Timeout'),
      DioExceptionType.connectionError =>
      ApiResponse<T>.noInternet('No Internet Connection'),
      DioExceptionType.badResponse => ApiResponse<T>.error('Some Error Occured'),
      DioExceptionType.unknown => ApiResponse<T>.error('Some Error Occured'),
      DioExceptionType.cancel => ApiResponse<T>.error('Request cancelled'),
      _ => ApiResponse<T>.error('Request cancelled'),
    };
  }
}