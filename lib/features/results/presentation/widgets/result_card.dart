import 'package:flutter/material.dart';

import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../domain/entities/result_entity.dart';

class ResultCard extends StatelessWidget {
  const ResultCard({super.key, required this.result, this.onTap});

  final ResultEntity result;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        decoration: AppDecorations.card(context),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.companyName,
                    style: context.textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (result.isAllotted) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Allotted ${result.allottedQuantity} units',
                      style: context.textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
            StatusChip(result.status),
          ],
        ),
      ),
    );
  }
}
