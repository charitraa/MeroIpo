import '../../features/accounts/domain/entities/account_entity.dart';
import '../../features/accounts/domain/usecases/get_accounts_usecase.dart';
import '../../features/ipo/domain/entities/ipo_entity.dart';
import '../../features/ipo/domain/usecases/bulk_apply_ipo_usecase.dart';
import '../../features/ipo/domain/usecases/get_open_ipos_usecase.dart';
import '../../shared/enums/apply_status.dart';
import '../constants/app_constants.dart';
import '../utils/logger.dart';
import 'notification_service.dart';

/// Outcome of one auto-apply run.
class AutoApplyReport {
  const AutoApplyReport({this.applied = 0, this.errors = 0, this.ipos = 0});
  final int applied;
  final int errors;
  final int ipos;
}

/// Core orchestration: fetch open IPOs, then apply every auto-apply-enabled
/// account to each. Used by both the background task and any manual trigger.
/// Lives in `core` because it deliberately spans the accounts, auth and ipo
/// feature domains.
class AutoApplyService {
  AutoApplyService({
    required GetOpenIposUsecase getOpenIpos,
    required GetAccountsUsecase getAccounts,
    required BulkApplyIpoUsecase bulkApply,
    required NotificationService notifications,
  })  : _getOpenIpos = getOpenIpos,
        _getAccounts = getAccounts,
        _bulkApply = bulkApply,
        _notifications = notifications;

  final GetOpenIposUsecase _getOpenIpos;
  final GetAccountsUsecase _getAccounts;
  final BulkApplyIpoUsecase _bulkApply;
  final NotificationService _notifications;
  final AppLogger _log = AppLogger('AutoApply');

  Future<AutoApplyReport> run({bool notify = true}) async {
    final accountsResult = await _getAccounts.call();
    final accounts = accountsResult
        .fold<List<AccountEntity>>((_) => const [], (a) => a)
        .where((a) => a.autoApplyEnabled)
        .toList();
    if (accounts.isEmpty) {
      _log.i('no auto-apply accounts; skipping');
      return const AutoApplyReport();
    }

    final iposResult = await _getOpenIpos.call();
    final ipos = iposResult.fold<List<IpoEntity>>((f) {
      _log.w('could not fetch open IPOs: ${f.message}');
      return const [];
    }, (list) => list.where((i) => i.isOpen).toList());
    if (ipos.isEmpty) return const AutoApplyReport();

    var applied = 0;
    var errors = 0;
    for (final ipo in ipos) {
      final result = await _bulkApply.call(
        ipo: ipo,
        accounts: accounts,
        quantity: AppConstants.defaultApplyQuantity,
      );
      result.fold(
        (f) => errors += accounts.length,
        (outcomes) {
          final a =
              outcomes.where((o) => o.status == ApplyStatus.applied).length;
          final e = outcomes.where((o) => o.status == ApplyStatus.error).length;
          applied += a;
          errors += e;
          if (notify && a > 0) {
            _notifications.show(
              title: 'Applied for ${ipo.companyName}',
              body: 'Submitted $a application(s)'
                  '${e > 0 ? ', $e failed' : ''}.',
            );
          }
        },
      );
    }

    _log.i('run complete: applied=$applied errors=$errors ipos=${ipos.length}');
    return AutoApplyReport(applied: applied, errors: errors, ipos: ipos.length);
  }
}
