import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/account_entity.dart';
import '../repositories/account_repository.dart';

class ToggleAutoApplyUsecase {
  const ToggleAutoApplyUsecase(this._repository);

  final AccountRepository _repository;

  Future<Either<Failure, AccountEntity>> call(String id, bool enabled) =>
      _repository.toggleAutoApply(id, enabled);
}
