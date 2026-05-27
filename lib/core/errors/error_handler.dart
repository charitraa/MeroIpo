import 'package:dio/dio.dart';

import 'app_exception.dart';
import 'failure.dart';

/// Maps low-level errors into [Failure]s for the `Left` side of `Either`.
class ErrorHandler {
  ErrorHandler._();

  /// Convert any thrown object (Dio errors, [AppException]s, anything) into a
  /// [Failure]. Never throws.
  static Failure handle(Object error) {
    if (error is AppException) return _fromAppException(error);
    if (error is DioException) return _fromDio(error);
    return const UnknownFailure();
  }

  static Failure _fromAppException(AppException e) => switch (e) {
        NetworkException() => NetworkFailure(e.message),
        TimeoutException() => TimeoutFailure(e.message),
        AuthException() => AuthFailure(e.message, e.statusCode),
        NotFoundException() => NotFoundFailure(e.message),
        CacheException() => CacheFailure(e.message),
        ValidationException() => ValidationFailure(e.message),
        ServerException() => ServerFailure(e.message, e.statusCode),
        UnknownException() => UnknownFailure(e.message),
      };

  static Failure _fromDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutFailure();
      case DioExceptionType.connectionError:
        return const NetworkFailure();
      case DioExceptionType.cancel:
        return const UnknownFailure('Request cancelled');
      case DioExceptionType.badCertificate:
        return const NetworkFailure('Bad SSL certificate');
      case DioExceptionType.badResponse:
        return _fromStatus(e);
      case DioExceptionType.unknown:
        return const NetworkFailure();
    }
  }

  static Failure _fromStatus(DioException e) {
    final status = e.response?.statusCode ?? 0;
    final message = _extractMessage(e.response?.data) ?? 'Request failed';
    if (status == 401 || status == 403) return AuthFailure(message, status);
    if (status == 404) return NotFoundFailure(message);
    if (status >= 500) return ServerFailure(message, status);
    return ServerFailure(message, status);
  }

  /// MeroShare error responses commonly carry `message` or `detail`.
  static String? _extractMessage(dynamic data) {
    if (data is Map) {
      final msg = data['message'] ?? data['detail'] ?? data['error'];
      if (msg is String && msg.trim().isNotEmpty) return msg;
    }
    return null;
  }
}
