import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/application_entity.dart';
import '../entities/ipo_entity.dart';

/// Open-IPO listing, application submission, and local application history.
/// Requires the active account's token to be set on the Dio client before
/// calling the remote methods (handled by the apply usecase after login).
abstract interface class IpoRepository {
  Future<Either<Failure, List<IpoEntity>>> getOpenIpos();

  /// Whether the currently authenticated account has already applied for
  /// [companyShareId].
  Future<Either<Failure, bool>> isAlreadyApplied(String companyShareId);

  /// Submits the application to MeroShare. Returns the server's message.
  Future<Either<Failure, String>> submitApplication({
    required String companyShareId,
    required String crn,
    required String customerId,
    required String demat,
    required int quantity,
  });

  // --- Local application history (Hive) ---

  Future<Either<Failure, List<ApplicationEntity>>> getApplications();

  Future<Either<Failure, Unit>> saveApplication(ApplicationEntity application);

  /// Cached open IPOs (last fetched), for offline display.
  Future<Either<Failure, List<IpoEntity>>> getCachedIpos();

  Future<Either<Failure, Unit>> cacheIpos(List<IpoEntity> ipos);
}
