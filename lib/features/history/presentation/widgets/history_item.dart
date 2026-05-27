import 'package:flutter/material.dart';

import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../providers/history_provider.dart';

class HistoryItem extends StatelessWidget {
  const HistoryItem({super.key, required this.data});

  final HistoryItemData data;

  @override
  Widget build(BuildContext context) {
    final app = data.application;
    return Container(
      decoration: AppDecorations.card(context),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  app.companyName,
                  style: context.textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${data.accountLabel} • ${app.sharesApplied} units',
                  style: context.textTheme.bodySmall,
                ),
                Text(
                  AppDateUtils.formatDateTime(app.appliedAt),
                  style: context.textTheme.labelSmall,
                ),
                if (app.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      app.errorMessage!,
                      style: context.textTheme.bodySmall
                          ?.copyWith(color: context.colors.error),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          StatusChip(app.status),
        ],
      ),
    );
  }
}
