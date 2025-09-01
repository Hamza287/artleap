import 'dart:async';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ⚠️ Adjust this import path if your AppData is elsewhere.
import '../../shared/app_persistance/app_data.dart';

class DioCore {
  late final Dio _dio;
  Dio get dio => _dio;

  // A simple lock so only one refresh runs at a time.
  static Completer<String?>? _refreshCompleter;

  DioCore(String baseUrl) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        validateStatus: (status) => true, // keep your existing behavior
        connectTimeout: const Duration(minutes: 3),
        sendTimeout: const Duration(minutes: 3),
        receiveTimeout: const Duration(minutes: 3),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        // Attach auth + useful IDs on every request if we have them
        onRequest: (options, handler) {
          final token = AppData.instance.token;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          // 👇 Optional: attach IDs as headers so backends that read from headers are happy
          final uid = AppData.instance.userId;
          if (uid != null && uid.isNotEmpty) {
            options.headers['userId'] = uid;
            options.headers['userid'] = uid; // tolerant casing
          }
          final fuid = AppData.instance.firebaseUid;
          if (fuid != null && fuid.isNotEmpty) {
            options.headers['firebaseUid'] = fuid;
            options.headers['firebaseuid'] = fuid;
          }

          handler.next(options);
        },

        // On 401, force-refresh Firebase ID token and retry once.
        onError: (e, handler) async {
          // 🔎 DEBUG HOOK: Log *any* server reply that mentions "user id is required"
          _debugLogIfUserIdRequired(e);

          final status = e.response?.statusCode;

          // Only attempt for 401 Unauthorized
          if (status == 401) {
            try {
              // If a refresh is already in progress, just await it.
              if (_refreshCompleter != null) {
                final fresh = await _refreshCompleter!.future;
                if (fresh != null && fresh.isNotEmpty) {
                  final retried = await _retryWithToken(_dio, e.requestOptions, fresh);
                  return handler.resolve(retried);
                }
                // If refresh failed, fall through to next(error)
                return handler.next(e);
              }

              // Start our own refresh
              _refreshCompleter = Completer<String?>();

              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                await user.reload();
                final freshToken = await user.getIdToken(true);
                if (freshToken != null && freshToken.isNotEmpty) {
                  AppData.instance.setToken(freshToken);
                  _refreshCompleter!.complete(freshToken);

                  // Retry original request with new token.
                  final retried = await _retryWithToken(_dio, e.requestOptions, freshToken);
                  _refreshCompleter = null;
                  return handler.resolve(retried);
                }
              }

              // No user or no token -> complete with null
              _refreshCompleter!.complete(null);
              _refreshCompleter = null;
              return handler.next(e);
            } catch (err) {
              // Make sure completer is completed on exceptions
              if (_refreshCompleter != null && !(_refreshCompleter!.isCompleted)) {
                _refreshCompleter!.complete(null);
              }
              _refreshCompleter = null;
              return handler.next(e);
            }
          }

          // Any other error = pass through
          return handler.next(e);
        },
      ),
    );

    // OPTIONAL: If you want to see *all* requests/responses while debugging, uncomment:
    // _dio.interceptors.add(LogInterceptor(
    //   request: true,
    //   requestHeader: true,
    //   requestBody: true,
    //   responseHeader: false,
    //   responseBody: true,
    //   error: true,
    // ));
  }

  // Helper to retry original request with a fresh token.
  static Future<Response<dynamic>> _retryWithToken(
      Dio dio,
      RequestOptions req,
      String token,
      ) async {
    // ⚠️ If the original body was FormData, its byte stream may have been consumed already.
    // To be safe, do NOT retry FormData automatically (see note below).
    if (req.data is FormData) {
      return Future.error(DioException(
        requestOptions: req,
        error:
        'Cannot safely retry FormData request after 401 (stream not rewindable). Ensure token is valid before upload.',
        type: DioExceptionType.unknown,
      ));
    }

    final opts = Options(
      method: req.method,
      headers: {
        // Preserve original headers and override Authorization
        ...?req.headers,
        'Authorization': 'Bearer $token',
      },
      responseType: req.responseType,
      contentType: req.contentType,
      sendTimeout: req.sendTimeout,
      receiveTimeout: req.receiveTimeout,
      followRedirects: req.followRedirects,
      validateStatus: req.validateStatus,
    );

    // Respect full URL vs relative path
    final pathOrUrl = req.path.startsWith('http')
        ? req.path
        : req.uri.toString().replaceFirst(req.baseUrl, '');

    return dio.request<dynamic>(
      pathOrUrl,
      data: req.data,
      queryParameters: req.queryParameters,
      options: opts,
      cancelToken: req.cancelToken,
      onReceiveProgress: req.onReceiveProgress,
      onSendProgress: req.onSendProgress,
    );
  }

  // ===== DEBUG HELPERS =====

  void _debugLogIfUserIdRequired(DioException e) {
    final res = e.response;
    final data = res?.data;
    final msg = _extractMessage(data)?.toLowerCase() ?? '';

    // Match common variants from backend messages
    final mentionsUserIdRequired = msg.contains('user id is required') ||
        msg.contains('userid is required') ||
        msg.contains('userId is required'.toLowerCase()) ||
        msg.contains('user_id is required');

    if (mentionsUserIdRequired) {
      final r = e.requestOptions;
      final url = r.uri.toString();
      // Highly focused log so you can see exactly what failed
      // (kept as prints to avoid depending on any logger)
      // You can adjust to debugPrint(...) if you prefer.
      // ignore: avoid_print
      print('❌ "user id is required" from ${r.method} $url');
      // ignore: avoid_print
      print('   headers: ${r.headers}');
      // ignore: avoid_print
      print('   query  : ${r.queryParameters}');
      if (r.data != null) {
        // ignore: avoid_print
        print('   body   : ${r.data}');
      }
      // ignore: avoid_print
      print('   status : ${res?.statusCode}');
      // ignore: avoid_print
      print('   response: ${res?.data}');
    }
  }

  String? _extractMessage(dynamic data) {
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
}
