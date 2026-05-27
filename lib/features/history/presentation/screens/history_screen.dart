import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/app_bottom_nav.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../ipo/presentation/providers/open_ipos_provider.dart';
import '../providers/history_provider.dart';
import '../widgets/history_item.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(historyProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      bottomNavigationBar: const AppBottomNav(),
      body: items.isEmpty
          ? const EmptyState(
              icon: Icons.history,
              title: 'No history yet',
              message: 'Your IPO applications will be logged here.',
            )
          : RefreshIndicator(
              onRefresh: () =>
                  ref.read(applicationsProvider.notifier).refresh(),
              child: ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: items.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (_, i) => HistoryItem(data: items[i]),
              ),
            ),
    );
  }
}
