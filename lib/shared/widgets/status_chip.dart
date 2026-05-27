import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';
import '../enums/apply_status.dart';

/// Colour-coded badge for an [ApplyStatus].
class StatusChip extends StatelessWidget {
  const StatusChip(this.status, {super.key});

  final ApplyStatus status;

  @override
  Widget build(BuildContext context) {
    final color = status.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            status.label,
            style: AppTextStyles.chip.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
