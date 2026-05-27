import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/ipo_entity.dart';
import '../repositories/ipo_repository.dart';

class GetOpenIposUsecase {
  const GetOpenIposUsecase(this._repository);

  final IpoRepository _repository;

  Future<Either<Failure, List<IpoEntity>>> call() => _repository.getOpenIpos();
}
