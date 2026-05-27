import 'package:equatable/equatable.dart';

/// A MeroShare session token obtained from login.
class AuthTokenEntity extends Equatable {
  const AuthTokenEntity({
    required this.token,
    this.issuedAt,
  });

  final String token;
  final DateTime? issuedAt;

  @override
  List<Object?> get props => [token, issuedAt];
}
