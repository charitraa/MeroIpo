import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/account_repository.dart';

class DeleteAccountUsecase {
  const DeleteAccountUsecase(this._repository);

  final AccountRepository _repository;

  Future<Either<Failure, Unit>> call(String id) =>
      _repository.deleteAccount(id);
}
