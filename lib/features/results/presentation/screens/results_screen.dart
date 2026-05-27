import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/app_bottom_nav.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../providers/results_provider.dart';
import '../widgets/allotment_summary.dart';
import '../widgets/result_card.dart';

class ResultsScreen extends ConsumerWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsync = ref.watch(resultsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Results')),
      bottomNavigationBar: const AppBottomNav(),
      body: resultsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorWidget(
          message: e.toString(),
          onRetry: () => ref.read(resultsProvider.notifier).refresh(),
        ),
        data: (results) {
          if (results.isEmpty) {
            return const EmptyState(
              icon: Icons.emoji_events_outlined,
              title: 'No results yet',
              message: 'Allotment results appear here once you have applied.',
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(resultsProvider.notifier).refresh(),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                const AllotmentSummary(),
                const SizedBox(height: AppSpacing.lg),
                ...results.map(
                  (r) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: ResultCard(
                      result: r,
                      onTap: () => context.pushNamed(
                        RouteNames.resultDetail,
                        pathParameters: {'companyShareId': r.companyShareId},
                        extra: r,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
