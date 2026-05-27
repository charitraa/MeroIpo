import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../accounts/presentation/providers/accounts_provider.dart';
import '../../../../shared/enums/apply_status.dart';
import '../../domain/entities/application_entity.dart';
import '../../domain/entities/ipo_entity.dart';
import 'open_ipos_provider.dart';

/// State of a bulk-apply run for one IPO.
class ApplyState {
  const ApplyState({
    this.isApplying = false,
    this.results = const [],
    this.error,
  });

  final bool isApplying;
  final List<ApplicationEntity> results;
  final String? error;

  int get appliedCount =>
      results.where((r) => r.status == ApplyStatus.applied).length;
  int get errorCount =>
      results.where((r) => r.status == ApplyStatus.error).length;

  ApplyState copyWith({
    bool? isApplying,
    List<ApplicationEntity>? results,
    String? error,
  }) =>
      ApplyState(
        isApplying: isApplying ?? this.isApplying,
        results: results ?? this.results,
        error: error,
      );
}

class ApplyNotifier extends Notifier<ApplyState> {
  @override
  ApplyState build() => const ApplyState();

  /// Applies all auto-apply-enabled accounts to [ipo].
  Future<void> applyAll(IpoEntity ipo, {int? quantity}) async {
    final accounts = (ref.read(accountsProvider).valueOrNull ?? const [])
        .where((a) => a.autoApplyEnabled)
        .toList();

    if (accounts.isEmpty) {
      state = state.copyWith(error: 'No auto-apply accounts to apply with');
      return;
    }

    state = state.copyWith(isApplying: true, error: null, results: const []);
    final result = await ref.read(bulkApplyIpoUsecaseProvider).call(
          ipo: ipo,
          accounts: accounts,
          quantity: quantity ?? AppConstants.defaultApplyQuantity,
        );

    result.fold(
      (failure) => state = state.copyWith(isApplying: false, error: failure.message),
      (outcomes) {
        state = state.copyWith(isApplying: false, results: outcomes);
        ref.invalidate(applicationsProvider);
      },
    );
  }

  void reset() => state = const ApplyState();
}

final applyProvider = NotifierProvider<ApplyNotifier, ApplyState>(
  ApplyNotifier.new,
);
