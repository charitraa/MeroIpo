import 'package:equatable/equatable.dart';

/// User-facing error type carried in the `Left` side of `Either<Failure, T>`.
sealed class Failure extends Equatable {
  const Failure(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'The request timed out']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error', int? statusCode])
      : super(statusCode: statusCode);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Invalid username or password', int? statusCode])
      : super(statusCode: statusCode);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Not found']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Could not read local data']);
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Invalid input']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Something went wrong']);
}
