import 'package:dio/dio.dart';
import '../../shared/console.dart';
import 'api_response.dart';

class HandlingResponse {
  static ApiResponse returnResponse(Response response) {
    var data = response.data;

    // Fallback to handling based on HTTP status codes
    return switch (response.statusCode) {
      200 => ApiResponse.completed(data),
      400 => ApiResponse.error('Some Error Occurred'),
      401 => ApiResponse.unAuthorised('Unauthorized'),
      403 => ApiResponse.error('Forbidden'),  
      404 => ApiResponse.error('Not Found'),
      500 => ApiResponse.error('Internal Server Error'),
      -6 => ApiResponse.error('No Internet Connection'),
      _ => ApiResponse.error('Unknown Error')
    };
  }

  static ApiResponse returnException(DioException exception) {
    console(exception);
    console('EXCEPTION');
    return switch (exception.type) {
      DioExceptionType.connectionTimeout =>
        ApiResponse.error('Connection Timeout'),
      DioExceptionType.connectionError =>
        ApiResponse.noInternet('No Internet Connection'),
      DioExceptionType.badResponse => ApiResponse.error('Some Error Occured'),
      DioExceptionType.unknown => ApiResponse.error('Some Error Occured'),
      DioExceptionType.cancel => ApiResponse.error('Request cancelled'),
      _ => ApiResponse.error('Request cancelled'),
    };
  }
}
