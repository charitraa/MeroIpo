import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/app_bottom_nav.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../providers/accounts_provider.dart';
import '../widgets/account_card.dart';
import '../widgets/delete_account_dialog.dart';

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Accounts')),
      bottomNavigationBar: const AppBottomNav(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed(RouteNames.addAccount),
        icon: const Icon(Icons.add),
        label: const Text('Add account'),
      ),
      body: accountsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorWidget(
          message: e.toString(),
          onRetry: () => ref.read(accountsProvider.notifier).refresh(),
        ),
        data: (accounts) {
          if (accounts.isEmpty) {
            return EmptyState(
              icon: Icons.people_outline,
              title: 'No accounts yet',
              message: 'Add a MeroShare account to start auto-applying.',
              actionLabel: 'Add account',
              onAction: () => context.pushNamed(RouteNames.addAccount),
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(accountsProvider.notifier).refresh(),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                96,
              ),
              itemCount: accounts.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, i) {
                final account = accounts[i];
                return AccountCard(
                  account: account,
                  onToggleAutoApply: (v) => _toggle(ref, account.id, v, context),
                  onDelete: () => _confirmDelete(context, ref, account),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _toggle(
    WidgetRef ref,
    String id,
    bool enabled,
    BuildContext context,
  ) async {
    final error =
        await ref.read(accountsProvider.notifier).toggleAutoApply(id, enabled);
    if (error != null && context.mounted) {
      context.showSnack(error, isError: true);
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    account,
  ) async {
    final confirmed = await DeleteAccountDialog.show(context, account);
    if (!confirmed) return;
    final error =
        await ref.read(accountsProvider.notifier).deleteAccount(account.id);
    if (context.mounted) {
      context.showSnack(
        error ?? 'Account deleted',
        isError: error != null,
      );
    }
  }
}
