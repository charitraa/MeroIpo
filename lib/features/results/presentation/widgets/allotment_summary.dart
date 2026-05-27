import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../providers/results_provider.dart';

/// Headline allotment stats: how many of the tracked applications were allotted.
class AllotmentSummary extends ConsumerWidget {
  const AllotmentSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(allotmentSummaryProvider);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.allotted.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        children: [
          const Icon(Icons.emoji_events, color: AppColors.allotted),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              '${summary.allotted} allotted of ${summary.total} tracked '
              'application(s)',
              style: context.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
