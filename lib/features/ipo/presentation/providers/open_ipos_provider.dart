import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../../accounts/presentation/providers/accounts_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/ipo_local_datasource.dart';
import '../../data/datasources/ipo_remote_datasource.dart';
import '../../data/repositories/ipo_repository_impl.dart';
import '../../domain/entities/application_entity.dart';
import '../../domain/entities/ipo_entity.dart';
import '../../domain/repositories/ipo_repository.dart';
import '../../domain/usecases/apply_ipo_usecase.dart';
import '../../domain/usecases/bulk_apply_ipo_usecase.dart';
import '../../domain/usecases/get_open_ipos_usecase.dart';

final ipoRemoteDataSourceProvider = Provider<IpoRemoteDataSource>(
  (ref) => IpoRemoteDataSource(ref.watch(dioProvider)),
);

final ipoLocalDataSourceProvider = Provider<IpoLocalDataSource>(
  (ref) => IpoLocalDataSource(
    applicationsBox: ref.watch(applicationsBoxProvider),
    listingsBox: ref.watch(ipoListingsBoxProvider),
  ),
);

final ipoRepositoryProvider = Provider<IpoRepository>(
  (ref) => IpoRepositoryImpl(
    remote: ref.watch(ipoRemoteDataSourceProvider),
    local: ref.watch(ipoLocalDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  ),
);

final getOpenIposUsecaseProvider = Provider(
  (ref) => GetOpenIposUsecase(ref.watch(ipoRepositoryProvider)),
);

final applyIpoUsecaseProvider = Provider(
  (ref) => ApplyIpoUsecase(ref.watch(ipoRepositoryProvider)),
);

final bulkApplyIpoUsecaseProvider = Provider(
  (ref) => BulkApplyIpoUsecase(
    accountRepository: ref.watch(accountRepositoryProvider),
    loginUsecase: ref.watch(loginUsecaseProvider),
    applyIpoUsecase: ref.watch(applyIpoUsecaseProvider),
  ),
);

/// Open IPOs fetched from MeroShare (cached in Hive).
class OpenIposNotifier extends AsyncNotifier<List<IpoEntity>> {
  @override
  Future<List<IpoEntity>> build() => _load();

  Future<List<IpoEntity>> _load() async {
    final result = await ref.read(getOpenIposUsecaseProvider).call();
    return result.fold((f) => throw f, (ipos) => ipos);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }
}

final openIposProvider =
    AsyncNotifierProvider<OpenIposNotifier, List<IpoEntity>>(
  OpenIposNotifier.new,
);

/// Local application history — shared by history and results features.
class ApplicationsNotifier extends AsyncNotifier<List<ApplicationEntity>> {
  @override
  Future<List<ApplicationEntity>> build() => _load();

  Future<List<ApplicationEntity>> _load() async {
    final result = await ref.read(ipoRepositoryProvider).getApplications();
    return result.fold((f) => throw f, (apps) => apps);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }
}

final applicationsProvider =
    AsyncNotifierProvider<ApplicationsNotifier, List<ApplicationEntity>>(
  ApplicationsNotifier.new,
);
