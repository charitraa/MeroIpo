import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import '../../../../shared/enums/apply_status.dart';
import '../../../ipo/data/models/ipo_application_model.dart';
import '../../domain/entities/result_entity.dart';
import '../../domain/repositories/result_repository.dart';

/// Derives results from recorded applications in the shared applications box.
/// (Live re-checking against MeroShare is performed by the background flow,
/// which updates the same records.)
class ResultRepositoryImpl implements ResultRepository {
  ResultRepositoryImpl(this._applicationsBox);

  final Box<IpoApplicationModel> _applicationsBox;

  @override
  Future<Either<Failure, List<ResultEntity>>> getResults() async {
    try {
      final results = _applicationsBox.values
          .where((m) => _hasResultRelevance(m.status))
          .map(
            (m) => ResultEntity(
              applicationId: m.id,
              companyShareId: m.companyShareId,
              companyName: m.companyName,
              accountId: m.accountId,
              status: ApplyStatus.fromName(m.status),
              checkedAt: m.resultCheckedAt,
            ),
          )
          .toList()
        ..sort((a, b) => (b.checkedAt ?? DateTime(0))
            .compareTo(a.checkedAt ?? DateTime(0)));
      return Right(results);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  bool _hasResultRelevance(String status) {
    final s = ApplyStatus.fromName(status);
    return s == ApplyStatus.applied ||
        s == ApplyStatus.allotted ||
        s == ApplyStatus.notAllotted;
  }
}
