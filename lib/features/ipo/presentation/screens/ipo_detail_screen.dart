import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../domain/entities/ipo_entity.dart';
import '../providers/open_ipos_provider.dart';
import '../widgets/bulk_apply_fab.dart';

class IpoDetailScreen extends ConsumerWidget {
  const IpoDetailScreen({
    super.key,
    required this.companyShareId,
    this.ipo,
  });

  final String companyShareId;
  final IpoEntity? ipo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resolved = ipo ??
        (ref.watch(openIposProvider).valueOrNull ?? const [])
            .where((e) => e.companyShareId == companyShareId)
            .firstOrNull;

    if (resolved == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const EmptyState(
          icon: Icons.search_off,
          title: 'IPO not found',
          message: 'This IPO is no longer available.',
        ),
      );
    }

    final apps = (ref.watch(applicationsProvider).valueOrNull ?? const [])
        .where((a) => a.companyShareId == companyShareId)
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(resolved.companyName)),
      floatingActionButton: BulkApplyFab(ipo: resolved),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Container(
            decoration: AppDecorations.card(context),
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(resolved.type.label, style: context.textTheme.labelLarge),
                const SizedBox(height: AppSpacing.sm),
                _row(context, 'Opens', AppDateUtils.formatDate(resolved.openDate)),
                _row(context, 'Closes',
                    AppDateUtils.formatDate(resolved.closeDate)),
                _row(context, 'Min units', '${resolved.minUnit}'),
                if (resolved.maxUnit > 0)
                  _row(context, 'Max units', '${resolved.maxUnit}'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Applications', style: context.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          if (apps.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: Text(
                'No applications yet. Tap "Apply all" to apply with your '
                'auto-apply accounts.',
                style: context.textTheme.bodyMedium,
              ),
            )
          else
            ...apps.map(
              (a) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Container(
                  decoration: AppDecorations.card(context),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${a.sharesApplied} units',
                                style: context.textTheme.bodyMedium),
                            if (a.errorMessage != null)
                              Text(
                                a.errorMessage!,
                                style: context.textTheme.bodySmall
                                    ?.copyWith(color: context.colors.error),
                              ),
                          ],
                        ),
                      ),
                      StatusChip(a.status),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: context.textTheme.bodySmall),
            Text(value, style: context.textTheme.bodyMedium),
          ],
        ),
      );
}
