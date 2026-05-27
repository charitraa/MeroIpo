import 'package:dio/dio.dart';

import '../constants/api_constants.dart';

/// Attaches a Bearer token to outgoing requests.
///
/// MeroShare tokens are per-account and short-lived, so the token is supplied
/// dynamically via [tokenProvider] rather than stored on the client. Requests
/// that already set an Authorization header (or opt out with `skipAuth`) are
/// left untouched.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this.tokenProvider);

  /// Returns the current token, or null when unauthenticated.
  final String? Function() tokenProvider;

  static const String skipAuthKey = 'skipAuth';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final skip = options.extra[skipAuthKey] == true;
    final hasHeader = options.headers.containsKey(ApiConstants.authHeader);
    if (!skip && !hasHeader) {
      final token = tokenProvider();
      if (token != null && token.isNotEmpty) {
        options.headers[ApiConstants.authHeader] = ApiConstants.bearer(token);
      }
    }
    handler.next(options);
  }
}
