import 'package:dartz/dartz.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/failure.dart';
import '../entities/account_entity.dart';
import '../repositories/account_repository.dart';

class AddAccountUsecase {
  const AddAccountUsecase(this._repository);

  final AccountRepository _repository;

  Future<Either<Failure, AccountEntity>> call(
    AccountEntity account,
    String password,
  ) async {
    final existing = await _repository.getAccounts();
    final overLimit = existing.fold(
      (_) => false,
      (list) => list.length >= AppConstants.maxAccounts,
    );
    if (overLimit) {
      return Left(
        ValidationFailure(
          'You can save up to ${AppConstants.maxAccounts} accounts',
        ),
      );
    }
    return _repository.addAccount(account, password);
  }
}
