import 'package:dio/dio.dart';
import 'api_response.dart';

class HandlingResponse {
  /// Converts an HTTP [response] into a typed [ApiResponse].
  /// - Any 2xx status is considered success (200..299), incl. 201/204.
  /// - Optionally parses the payload via [fromJson].
  /// - Extracts a useful error message when possible.
  static ApiResponse<T> returnResponse<T>(
      Response response, {
        T Function(dynamic)? fromJson,
      }) {
    final int code = response.statusCode ?? 0;
    final dynamic data = response.data;

    // ✅ Success for ANY 2xx
    if (code >= 200 && code < 300) {
      // 204 No Content -> still return completed with null/empty payload
      final T parsed =
      fromJson != null ? fromJson(data) : (data is T ? data : (null as T));
      return ApiResponse<T>.completed(parsed);
    }

    // 🤝 Optional: treat 409 as success if backend returns an existing user payload
    if (code == 409 && _hasUserPayload(data)) {
      final T parsed =
      fromJson != null ? fromJson(data) : (data is T ? data : (null as T));
      return ApiResponse<T>.completed(parsed);
    }

    // Fallbacks for common error codes, with message extraction
    final String msg = _extractMessage(data) ?? _defaultMessage(code);

    switch (code) {
      case 400:
        return ApiResponse<T>.error(msg.isEmpty ? 'Bad Request' : msg);
      case 401:
        return ApiResponse<T>.unAuthorised(msg.isEmpty ? 'Unauthorized' : msg);
      case 403:
        return ApiResponse<T>.error(msg.isEmpty ? 'Forbidden' : msg);
      case 404:
        return ApiResponse<T>.error(msg.isEmpty ? 'Not Found' : msg);
      case 409:
        return ApiResponse<T>.error(msg.isEmpty ? 'Conflict' : msg);
      case 422:
        return ApiResponse<T>.error(msg.isEmpty ? 'Unprocessable Entity' : msg);
      case 500:
        return ApiResponse<T>.error(msg.isEmpty ? 'Internal Server Error' : msg);
      default:
        return ApiResponse<T>.error(
          msg.isEmpty ? 'Request failed ($code)' : msg,
        );
    }
  }

  /// Standardized exception -> ApiResponse mapping with clearer messages.
  static ApiResponse<T> returnException<T>(DioException exception) {
    // Try to surface server-provided message if available
    final String? serverMsg = _extractMessage(exception.response?.data);

    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
        return ApiResponse<T>.error('Connection timeout');
      case DioExceptionType.sendTimeout:
        return ApiResponse<T>.error('Send timeout');
      case DioExceptionType.receiveTimeout:
        return ApiResponse<T>.error('Receive timeout');
      case DioExceptionType.badCertificate:
        return ApiResponse<T>.error('Bad SSL certificate');
      case DioExceptionType.cancel:
        return ApiResponse<T>.error('Request cancelled');
      case DioExceptionType.connectionError:
        return ApiResponse<T>.noInternet('No internet connection');
      case DioExceptionType.badResponse:
      // Delegate to returnResponse-style handling if we do have a response
        final res = exception.response;
        if (res != null) {
          return returnResponse<T>(res);
        }
        return ApiResponse<T>.error(serverMsg ?? 'Unexpected server response');
      case DioExceptionType.unknown:
        return ApiResponse<T>.error(serverMsg ?? 'Some error occurred');
    }
  }

  // ---------- helpers ----------

  static String? _extractMessage(dynamic data) {
    if (data is Map) {
      // common API patterns
      if (data['message'] is String && (data['message'] as String).isNotEmpty) {
        return data['message'] as String;
      }
      if (data['error'] is String && (data['error'] as String).isNotEmpty) {
        return data['error'] as String;
      }
      if (data['errors'] is List && (data['errors'] as List).isNotEmpty) {
        final first = (data['errors'] as List).first;
        if (first is String) return first;
        if (first is Map && first['message'] is String) return first['message'] as String;
      }
    } else if (data is String && data.trim().isNotEmpty) {
      return data;
    }
    return null;
  }

  static String _defaultMessage(int code) {
    switch (code) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not found';
      case 409:
        return 'Conflict';
      case 422:
        return 'Unprocessable entity';
      case 500:
        return 'Server error';
      default:
        return 'Request failed ($code)';
    }
  }

  static bool _hasUserPayload(dynamic data) =>
      data is Map && data['user'] != null;
}
