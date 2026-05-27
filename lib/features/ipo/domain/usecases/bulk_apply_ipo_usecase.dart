import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/errors/failure.dart';
// Cross-feature domain composition (see CLAUDE.md): orchestration usecases may
// compose other features' domain contracts — never their presentation layer.
import '../../../accounts/domain/entities/account_entity.dart';
import '../../../accounts/domain/repositories/account_repository.dart';
import '../../../auth/domain/usecases/login_usecase.dart';
import '../../../../shared/enums/apply_status.dart';
import '../entities/application_entity.dart';
import '../entities/ipo_entity.dart';
import 'apply_ipo_usecase.dart';

/// Applies every supplied account to a single IPO, sequentially: for each
/// account it reads the stored password, logs in, then delegates to
/// [ApplyIpoUsecase]. Always resolves with one [ApplicationEntity] per account
/// (login failures recorded as `status == error`).
class BulkApplyIpoUsecase {
  BulkApplyIpoUsecase({
    required AccountRepository accountRepository,
    required LoginUsecase loginUsecase,
    required ApplyIpoUsecase applyIpoUsecase,
    Uuid? uuid,
  })  : _accounts = accountRepository,
        _login = loginUsecase,
        _apply = applyIpoUsecase,
        _uuid = uuid ?? const Uuid();

  final AccountRepository _accounts;
  final LoginUsecase _login;
  final ApplyIpoUsecase _apply;
  final Uuid _uuid;

  Future<Either<Failure, List<ApplicationEntity>>> call({
    required IpoEntity ipo,
    required List<AccountEntity> accounts,
    required int quantity,
  }) async {
    final outcomes = <ApplicationEntity>[];

    for (final account in accounts) {
      final outcome = await _applyOne(ipo, account, quantity);
      outcomes.add(outcome);
    }
    return Right(outcomes);
  }

  Future<ApplicationEntity> _applyOne(
    IpoEntity ipo,
    AccountEntity account,
    int quantity,
  ) async {
    ApplicationEntity errorOutcome(String message) => ApplicationEntity(
          id: _uuid.v4(),
          companyShareId: ipo.companyShareId,
          companyName: ipo.companyName,
          accountId: account.id,
          status: ApplyStatus.error,
          sharesApplied: quantity,
          errorMessage: message,
        );

    final passwordResult = await _accounts.getPassword(account.id);
    final password = passwordResult.fold((_) => null, (p) => p);
    if (password == null) return errorOutcome('No saved password');

    final loginResult = await _login.call(
      accountId: account.id,
      dpId: account.dpId,
      username: account.username,
      password: password,
    );
    final loginFailure = loginResult.fold((f) => f, (_) => null);
    if (loginFailure != null) return errorOutcome(loginFailure.message);

    final applyResult = await _apply.call(
      companyShareId: ipo.companyShareId,
      companyName: ipo.companyName,
      accountId: account.id,
      crn: account.crn,
      customerId: account.bankId,
      demat: account.boid,
      quantity: quantity,
    );
    return applyResult.fold((f) => errorOutcome(f.message), (entity) => entity);
  }
}
