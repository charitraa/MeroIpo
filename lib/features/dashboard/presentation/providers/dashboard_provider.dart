import 'package:flutter_riverpod/flutter_riverpod.dart';

// The dashboard is an aggregation surface: it composes the read-only providers
// of other features to present an overview.
import '../../../accounts/presentation/providers/accounts_provider.dart';
import '../../../ipo/domain/entities/ipo_entity.dart';
import '../../../ipo/presentation/providers/open_ipos_provider.dart';
import '../../../results/presentation/providers/results_provider.dart';
import '../../../../shared/enums/apply_status.dart';

class DashboardSummary {
  const DashboardSummary({
    required this.totalAccounts,
    required this.autoApplyAccounts,
    required this.openIpoCount,
    required this.appliedCount,
    required this.allottedCount,
    this.nextOpenIpo,
  });

  final int totalAccounts;
  final int autoApplyAccounts;
  final int openIpoCount;
  final int appliedCount;
  final int allottedCount;
  final IpoEntity? nextOpenIpo;

  bool get hasOpenIpos => openIpoCount > 0;
}

final dashboardSummaryProvider = Provider<DashboardSummary>((ref) {
  final accounts = ref.watch(accountsProvider).valueOrNull ?? const [];
  final ipos = ref.watch(openIposProvider).valueOrNull ?? const [];
  final apps = ref.watch(applicationsProvider).valueOrNull ?? const [];
  final summary = ref.watch(allotmentSummaryProvider);

  return DashboardSummary(
    totalAccounts: accounts.length,
    autoApplyAccounts: accounts.where((a) => a.autoApplyEnabled).length,
    openIpoCount: ipos.length,
    appliedCount: apps.where((a) => a.status == ApplyStatus.applied).length,
    allottedCount: summary.allotted,
    nextOpenIpo: ipos.isEmpty ? null : ipos.first,
  );
});
