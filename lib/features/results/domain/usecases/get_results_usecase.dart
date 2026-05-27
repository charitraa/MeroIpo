import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/result_entity.dart';
import '../repositories/result_repository.dart';

class GetResultsUsecase {
  const GetResultsUsecase(this._repository);

  final ResultRepository _repository;

  Future<Either<Failure, List<ResultEntity>>> call() =>
      _repository.getResults();
}
