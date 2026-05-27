import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/auth_token_entity.dart';

abstract interface class AuthRepository {
  /// Logs into MeroShare and returns a session token. The token is also stored
  /// securely against [accountId] and set on the shared Dio client.
  Future<Either<Failure, AuthTokenEntity>> login({
    required String accountId,
    required String dpId,
    required String username,
    required String password,
  });
}
