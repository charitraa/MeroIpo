import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/account_entity.dart';
import '../repositories/account_repository.dart';

class GetAccountsUsecase {
  const GetAccountsUsecase(this._repository);

  final AccountRepository _repository;

  Future<Either<Failure, List<AccountEntity>>> call() =>
      _repository.getAccounts();
}
