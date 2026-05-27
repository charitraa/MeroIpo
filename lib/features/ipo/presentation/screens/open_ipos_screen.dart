import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/app_bottom_nav.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../providers/open_ipos_provider.dart';
import '../widgets/ipo_card.dart';

class OpenIposScreen extends ConsumerWidget {
  const OpenIposScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iposAsync = ref.watch(openIposProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Open IPOs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(openIposProvider.notifier).refresh(),
            tooltip: 'Refresh',
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(),
      body: iposAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorWidget(
          message: e.toString(),
          onRetry: () => ref.read(openIposProvider.notifier).refresh(),
        ),
        data: (ipos) {
          if (ipos.isEmpty) {
            return EmptyState(
              icon: Icons.trending_up_outlined,
              title: 'No open IPOs',
              message: 'There are no IPOs open for application right now.',
              actionLabel: 'Refresh',
              onAction: () => ref.read(openIposProvider.notifier).refresh(),
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(openIposProvider.notifier).refresh(),
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: ipos.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, i) {
                final ipo = ipos[i];
                return IpoCard(
                  ipo: ipo,
                  onTap: () => context.pushNamed(
                    RouteNames.ipoDetail,
                    pathParameters: {'companyShareId': ipo.companyShareId},
                    extra: ipo,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
