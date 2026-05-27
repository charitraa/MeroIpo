import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/logging_interceptor.dart';

/// Talks to MeroShare's auth endpoint. Returns the raw JWT string.
class AuthRemoteDataSource {
  AuthRemoteDataSource(this._dio);

  final Dio _dio;

  /// POST /auth/loginWithClientId/{dpId}. MeroShare returns the JWT either in
  /// the response body (`token`) or the `Authorization` response header.
  Future<String> login({
    required String dpId,
    required String username,
    required String password,
  }) async {
    final response = await _dio.post(
      ApiConstants.loginWithClientId(dpId),
      data: {
        'clientId': dpId,
        'username': username,
        'password': password,
      },
      options: Options(extra: skipAuthExtra),
    );

    final data = response.data;
    String? token;
    if (data is Map && data['token'] is String) {
      token = data['token'] as String;
    }
    token ??= _tokenFromHeader(response.headers);

    if (token == null || token.isEmpty) {
      throw const AuthException('Login succeeded but no token was returned');
    }
    return token.replaceFirst('Bearer ', '');
  }

  String? _tokenFromHeader(Headers headers) {
    final auth = headers.value(ApiConstants.authHeader);
    return (auth == null || auth.isEmpty) ? null : auth;
  }
}
