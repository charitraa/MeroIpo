import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/errors/failure.dart';
import '../../../../shared/enums/apply_status.dart';
import '../entities/application_entity.dart';
import '../repositories/ipo_repository.dart';

/// Applies a single, already-authenticated account to one IPO.
///
/// The caller must have logged the account in (token set on the Dio client)
/// before invoking this. The outcome is always recorded as an
/// [ApplicationEntity]: submission errors are captured as `status == error`
/// rather than thrown, so bulk runs are resilient. A `Left` is returned only
/// when even persistence fails.
class ApplyIpoUsecase {
  ApplyIpoUsecase(this._repository, {Uuid? uuid})
      : _uuid = uuid ?? const Uuid();

  final IpoRepository _repository;
  final Uuid _uuid;

  Future<Either<Failure, ApplicationEntity>> call({
    required String companyShareId,
    required String companyName,
    required String accountId,
    required String crn,
    required String customerId,
    required String demat,
    required int quantity,
  }) async {
    ApplicationEntity outcome(ApplyStatus status, {String? error}) =>
        ApplicationEntity(
          id: _uuid.v4(),
          companyShareId: companyShareId,
          companyName: companyName,
          accountId: accountId,
          status: status,
          sharesApplied: quantity,
          appliedAt: status == ApplyStatus.applied ? DateTime.now() : null,
          errorMessage: error,
        );

    // Skip if already applied.
    final appliedCheck = await _repository.isAlreadyApplied(companyShareId);
    final ApplicationEntity entity = await appliedCheck.fold(
      (failure) async => outcome(ApplyStatus.error, error: failure.message),
      (already) async {
        if (already) return outcome(ApplyStatus.applied);
        final submit = await _repository.submitApplication(
          companyShareId: companyShareId,
          crn: crn,
          customerId: customerId,
          demat: demat,
          quantity: quantity,
        );
        return submit.fold(
          (failure) => outcome(ApplyStatus.error, error: failure.message),
          (_) => outcome(ApplyStatus.applied),
        );
      },
    );

    final saved = await _repository.saveApplication(entity);
    return saved.fold((failure) => Left(failure), (_) => Right(entity));
  }
}
