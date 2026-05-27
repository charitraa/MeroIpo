import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/ipo_repository.dart';

class CheckAlreadyAppliedUsecase {
  const CheckAlreadyAppliedUsecase(this._repository);

  final IpoRepository _repository;

  Future<Either<Failure, bool>> call(String companyShareId) =>
      _repository.isAlreadyApplied(companyShareId);
}
