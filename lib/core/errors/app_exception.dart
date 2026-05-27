/// Low-level exceptions thrown inside the data layer. These are caught by
/// repositories and converted into [Failure]s — they never reach the UI.
sealed class AppException implements Exception {
  const AppException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => '$runtimeType($message)';
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection']);
}

class TimeoutException extends AppException {
  const TimeoutException([super.message = 'The request timed out']);
}

class ServerException extends AppException {
  const ServerException([super.message = 'Server error', int? statusCode])
      : super(statusCode: statusCode);
}

class AuthException extends AppException {
  const AuthException([super.message = 'Authentication failed', int? statusCode])
      : super(statusCode: statusCode);
}

class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Resource not found']);
}

class CacheException extends AppException {
  const CacheException([super.message = 'Local storage error']);
}

class ValidationException extends AppException {
  const ValidationException([super.message = 'Invalid input']);
}

/// Fallback for anything unexpected.
class UnknownException extends AppException {
  const UnknownException([super.message = 'Something went wrong']);
}
