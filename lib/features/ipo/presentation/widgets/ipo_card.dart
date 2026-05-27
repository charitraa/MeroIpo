import 'package:flutter/material.dart';

import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/ipo_entity.dart';
import 'apply_status_badge.dart';

class IpoCard extends StatelessWidget {
  const IpoCard({super.key, required this.ipo, this.onTap});

  final IpoEntity ipo;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        decoration: AppDecorations.card(context),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    ipo.companyName,
                    style: context.textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (ipo.scrip != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: AppDecorations.pill(context.colors.secondary),
                    child: Text(
                      ipo.scrip!,
                      style: TextStyle(
                        color: context.colors.secondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(ipo.type.label, style: context.textTheme.bodySmall),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Icon(Icons.event_outlined,
                    size: 16, color: context.textTheme.bodySmall?.color),
                const SizedBox(width: 4),
                Text(
                  AppDateUtils.formatDate(ipo.closeDate),
                  style: context.textTheme.bodySmall,
                ),
                const Spacer(),
                Text(
                  AppDateUtils.closesIn(ipo.closeDate),
                  style: context.textTheme.labelMedium
                      ?.copyWith(color: context.colors.primary),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ApplyStatusBadge(companyShareId: ipo.companyShareId),
          ],
        ),
      ),
    );
  }
}
