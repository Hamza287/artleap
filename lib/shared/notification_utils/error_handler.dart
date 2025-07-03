import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ErrorHandler {
  static void showError(dynamic error) {
    debugPrint('Notification Error: ${error.toString()}');
  }

  static Exception handleDioError(DioException error) {
    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final data = error.response!.data;

      switch (statusCode) {
        case 400:
          return Exception(data['message'] ?? 'Bad request');
        case 401:
          return Exception('Unauthorized - Please login again');
        case 403:
          return Exception('Forbidden - You don\'t have permission');
        case 404:
          return Exception('Resource not found');
        case 500:
          return Exception('Server error - Please try again later');
        default:
          return Exception('Network error occurred');
      }
    } else {
      return Exception('Network error - Please check your connection');
    }
  }

  static Exception handleResponseError(Response response) {
    final statusCode = response.statusCode;
    final data = response.data;

    switch (statusCode) {
      case 400:
        return Exception(data['message'] ?? 'Bad request');
      case 401:
        return Exception('Unauthorized - Please login again');
      case 403:
        return Exception('Forbidden - You don\'t have permission');
      case 404:
        return Exception('Resource not found');
      case 500:
        return Exception('Server error - Please try again later');
      default:
        return Exception('Unexpected error occurred');
    }
  }

  static Exception handleError(dynamic error) {
    if (error is Exception) return error;
    return Exception('An unexpected error occurred ${error.toString()}');
  }
}