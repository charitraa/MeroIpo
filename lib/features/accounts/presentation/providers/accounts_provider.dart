import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../data/datasources/account_local_datasource.dart';
import '../../data/repositories/account_repository_impl.dart';
import '../../domain/entities/account_entity.dart';
import '../../domain/repositories/account_repository.dart';
import '../../domain/usecases/add_account_usecase.dart';
import '../../domain/usecases/delete_account_usecase.dart';
import '../../domain/usecases/get_accounts_usecase.dart';
import '../../domain/usecases/toggle_auto_apply_usecase.dart';

final accountLocalDataSourceProvider = Provider<AccountLocalDataSource>(
  (ref) => AccountLocalDataSource(
    box: ref.watch(accountsBoxProvider),
    secureStorage: ref.watch(secureStorageProvider),
  ),
);

final accountRepositoryProvider = Provider<AccountRepository>(
  (ref) => AccountRepositoryImpl(ref.watch(accountLocalDataSourceProvider)),
);

final getAccountsUsecaseProvider = Provider(
  (ref) => GetAccountsUsecase(ref.watch(accountRepositoryProvider)),
);
final addAccountUsecaseProvider = Provider(
  (ref) => AddAccountUsecase(ref.watch(accountRepositoryProvider)),
);
final deleteAccountUsecaseProvider = Provider(
  (ref) => DeleteAccountUsecase(ref.watch(accountRepositoryProvider)),
);
final toggleAutoApplyUsecaseProvider = Provider(
  (ref) => ToggleAutoApplyUsecase(ref.watch(accountRepositoryProvider)),
);

/// Holds the list of saved accounts; the single source of truth for the UI.
class AccountsNotifier extends AsyncNotifier<List<AccountEntity>> {
  @override
  Future<List<AccountEntity>> build() => _load();

  Future<List<AccountEntity>> _load() async {
    final result = await ref.read(getAccountsUsecaseProvider).call();
    return result.fold((f) => throw f, (accounts) => accounts);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  /// Returns null on success, or an error message on failure.
  Future<String?> addAccount(AccountEntity account, String password) async {
    final result =
        await ref.read(addAccountUsecaseProvider).call(account, password);
    return result.fold((f) => f.message, (_) {
      ref.invalidateSelf();
      return null;
    });
  }

  Future<String?> deleteAccount(String id) async {
    final result = await ref.read(deleteAccountUsecaseProvider).call(id);
    return result.fold((f) => f.message, (_) {
      ref.invalidateSelf();
      return null;
    });
  }

  Future<String?> toggleAutoApply(String id, bool enabled) async {
    final result =
        await ref.read(toggleAutoApplyUsecaseProvider).call(id, enabled);
    return result.fold((f) => f.message, (_) {
      ref.invalidateSelf();
      return null;
    });
  }
}

final accountsProvider =
    AsyncNotifierProvider<AccountsNotifier, List<AccountEntity>>(
  AccountsNotifier.new,
);

/// Count of accounts with auto-apply enabled — handy for the dashboard.
final autoApplyEnabledCountProvider = Provider<int>((ref) {
  final accounts = ref.watch(accountsProvider).valueOrNull ?? const [];
  return accounts.where((a) => a.autoApplyEnabled).length;
});
