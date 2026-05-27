import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/result_entity.dart';

abstract interface class ResultRepository {
  /// Allotment results derived from recorded applications.
  Future<Either<Failure, List<ResultEntity>>> getResults();
}
