import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/app_bottom_nav.dart';
import '../../../accounts/presentation/providers/accounts_provider.dart';
import '../../../ipo/presentation/providers/open_ipos_provider.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/account_status_row.dart';
import '../widgets/open_ipo_banner.dart';
import '../widgets/summary_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    await Future.wait([
      ref.read(accountsProvider.notifier).refresh(),
      ref.read(openIposProvider.notifier).refresh(),
    ]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(dashboardSummaryProvider);
    final accounts = ref.watch(accountsProvider).valueOrNull ?? const [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.pushNamed(RouteNames.settings),
            tooltip: 'Settings',
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(),
      body: RefreshIndicator(
        onRefresh: () => _refresh(ref),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            if (summary.nextOpenIpo != null) ...[
              OpenIpoBanner(
                ipo: summary.nextOpenIpo!,
                onTap: () => context.goNamed(RouteNames.openIpos),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              childAspectRatio: 1.5,
              children: [
                SummaryCard(
                  icon: Icons.people,
                  value: '${summary.totalAccounts}',
                  label: '${summary.autoApplyAccounts} auto-apply',
                  color: AppColors.primary,
                  onTap: () => context.goNamed(RouteNames.accounts),
                ),
                SummaryCard(
                  icon: Icons.trending_up,
                  value: '${summary.openIpoCount}',
                  label: 'Open IPOs',
                  color: AppColors.secondary,
                  onTap: () => context.goNamed(RouteNames.openIpos),
                ),
                SummaryCard(
                  icon: Icons.check_circle,
                  value: '${summary.appliedCount}',
                  label: 'Applied',
                  color: AppColors.applied,
                  onTap: () => context.goNamed(RouteNames.history),
                ),
                SummaryCard(
                  icon: Icons.emoji_events,
                  value: '${summary.allottedCount}',
                  label: 'Allotted',
                  color: AppColors.allotted,
                  onTap: () => context.goNamed(RouteNames.results),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Accounts', style: context.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            if (accounts.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Text(
                  'No accounts yet. Add one to start auto-applying.',
                  style: context.textTheme.bodyMedium,
                ),
              )
            else
              ...accounts.take(5).map((a) => AccountStatusRow(account: a)),
          ],
        ),
      ),
    );
  }
}
