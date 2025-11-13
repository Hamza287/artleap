import 'package:dio/dio.dart';

class ErrorHandler {
  static String handleDioError(DioException error) {
    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final data = error.response!.data;

      switch (statusCode) {
        case 400:
          return data['message'] ?? 'Bad request';
        case 401:
          return 'Unauthorized - Please login again';
        case 403:
          return 'Forbidden - You don\'t have permission';
        case 404:
          return 'Resource not found';
        case 500:
          return 'Server error - Please try again later';
        default:
          return 'Network error occurred';
      }
    } else {
      return 'Network error - Please check your connection';
    }
  }

  static String handleResponseError(Response response) {
    final statusCode = response.statusCode;
    final data = response.data;

    switch (statusCode) {
      case 400:
        return data['message'] ?? 'Bad request';
      case 401:
        return 'Unauthorized - Please login again';
      case 403:
        return 'Forbidden - You don\'t have permission';
      case 404:
        return 'Resource not found';
      case 500:
        return 'Server error - Please try again later';
      default:
        return 'Unexpected error occurred';
    }
  }

  static String handleError(dynamic error) {
    if (error is DioException) return handleDioError(error);
    if (error is String) return error;
    return 'An unexpected error occurred';
  }
}