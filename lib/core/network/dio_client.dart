import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../constants/app_constants.dart';
import 'auth_interceptor.dart';
import 'logging_interceptor.dart';

/// Holds the Bearer token for the account currently being acted upon.
///
/// MeroShare tokens are per-account. The auto-apply flow is sequential
/// (one account at a time), so a single mutable holder is sufficient; callers
/// set [token] right after login. Datasources may also pass the token per
/// request via headers, which takes precedence.
class TokenStore {
  String? token;
  void clear() => token = null;
}

/// Builds the configured Dio singleton for MeroShare.
class DioClient {
  DioClient({TokenStore? tokenStore}) : tokenStore = tokenStore ?? TokenStore();

  final TokenStore tokenStore;

  Dio build() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        validateStatus: (status) => status != null && status < 400,
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(() => tokenStore.token),
      LoggingInterceptor(),
    ]);

    return dio;
  }
}
