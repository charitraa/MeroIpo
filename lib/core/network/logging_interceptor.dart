import 'package:dio/dio.dart';

import '../utils/logger.dart';
import 'auth_interceptor.dart';

/// Pretty-prints requests/responses. Redacts auth headers and credential
/// fields so tokens and passwords never reach the logs.
class LoggingInterceptor extends Interceptor {
  LoggingInterceptor();

  final AppLogger _log = AppLogger('HTTP');

  static const _sensitiveBodyKeys = {'password', 'token', 'crnNumber'};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _log.d('→ ${options.method} ${options.uri}');
    final body = _redactBody(options.data);
    if (body != null) _log.d('  body: $body');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _log.d('← ${response.statusCode} ${response.requestOptions.uri}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _log.w(
      '✗ ${err.response?.statusCode ?? '-'} ${err.requestOptions.uri} '
      '(${err.type.name})',
    );
    handler.next(err);
  }

  Object? _redactBody(Object? data) {
    if (data is Map) {
      return {
        for (final entry in data.entries)
          entry.key: _sensitiveBodyKeys.contains(entry.key)
              ? '***'
              : entry.value,
      };
    }
    return null; // don't log non-map bodies (may contain credentials)
  }
}

/// Marker so callers can opt requests out of auth via `Options(extra: ...)`.
const Map<String, dynamic> skipAuthExtra = {AuthInterceptor.skipAuthKey: true};
