import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../../ipo/presentation/providers/open_ipos_provider.dart';
import '../../data/datasources/result_remote_datasource.dart';
import '../../data/repositories/result_repository_impl.dart';
import '../../domain/entities/result_entity.dart';
import '../../domain/repositories/result_repository.dart';
import '../../domain/usecases/get_results_usecase.dart';

final resultRemoteDataSourceProvider = Provider<ResultRemoteDataSource>(
  (ref) => ResultRemoteDataSource(ref.watch(dioProvider)),
);

final resultRepositoryProvider = Provider<ResultRepository>(
  (ref) => ResultRepositoryImpl(ref.watch(applicationsBoxProvider)),
);

final getResultsUsecaseProvider = Provider(
  (ref) => GetResultsUsecase(ref.watch(resultRepositoryProvider)),
);

/// Allotment results. Rebuilds when the application history changes.
class ResultsNotifier extends AsyncNotifier<List<ResultEntity>> {
  @override
  Future<List<ResultEntity>> build() {
    // Re-derive whenever applications change.
    ref.watch(applicationsProvider);
    return _load();
  }

  Future<List<ResultEntity>> _load() async {
    final result = await ref.read(getResultsUsecaseProvider).call();
    return result.fold((f) => throw f, (results) => results);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }
}

final resultsProvider =
    AsyncNotifierProvider<ResultsNotifier, List<ResultEntity>>(
  ResultsNotifier.new,
);

/// Quick summary used by the dashboard / allotment summary widget.
final allotmentSummaryProvider = Provider<({int allotted, int total})>((ref) {
  final results = ref.watch(resultsProvider).valueOrNull ?? const [];
  final allotted = results.where((r) => r.isAllotted).length;
  return (allotted: allotted, total: results.length);
});
