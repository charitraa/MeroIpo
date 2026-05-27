import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/auth_token_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUsecase {
  const LoginUsecase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, AuthTokenEntity>> call({
    required String accountId,
    required String dpId,
    required String username,
    required String password,
  }) =>
      _repository.login(
        accountId: accountId,
        dpId: dpId,
        username: username,
        password: password,
      );
}
