import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../domain/entities/result_entity.dart';
import '../providers/results_provider.dart';

class ResultDetailScreen extends ConsumerWidget {
  const ResultDetailScreen({
    super.key,
    required this.companyShareId,
    this.result,
  });

  final String companyShareId;
  final ResultEntity? result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final all = ref.watch(resultsProvider).valueOrNull ?? const [];
    final matches = result != null
        ? [result!]
        : all.where((r) => r.companyShareId == companyShareId).toList();

    if (matches.isEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: const EmptyState(
          icon: Icons.search_off,
          title: 'Result not found',
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(matches.first.companyName)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          for (final r in matches)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Container(
                decoration: AppDecorations.card(context),
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Account ${r.accountId.substring(0, 6)}…',
                            style: context.textTheme.bodyMedium),
                        StatusChip(r.status),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    if (r.isAllotted)
                      Text('Allotted ${r.allottedQuantity} units',
                          style: context.textTheme.bodyMedium),
                    Text(
                      'Checked: ${AppDateUtils.formatDateTime(r.checkedAt)}',
                      style: context.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
