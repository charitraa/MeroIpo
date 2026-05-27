import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Lifecycle of a single IPO application for one account.
enum ApplyStatus {
  pending,
  applied,
  allotted,
  notAllotted,
  error,
  skipped;

  static ApplyStatus fromName(String? name) => ApplyStatus.values.firstWhere(
        (s) => s.name == name,
        orElse: () => ApplyStatus.pending,
      );

  String get label => switch (this) {
        ApplyStatus.pending => 'Pending',
        ApplyStatus.applied => 'Applied',
        ApplyStatus.allotted => 'Allotted',
        ApplyStatus.notAllotted => 'Not allotted',
        ApplyStatus.error => 'Error',
        ApplyStatus.skipped => 'Skipped',
      };

  Color get color => switch (this) {
        ApplyStatus.pending => AppColors.pending,
        ApplyStatus.applied => AppColors.applied,
        ApplyStatus.allotted => AppColors.allotted,
        ApplyStatus.notAllotted => AppColors.notAllotted,
        ApplyStatus.error => AppColors.error,
        ApplyStatus.skipped => AppColors.skipped,
      };

  IconData get icon => switch (this) {
        ApplyStatus.pending => Icons.hourglass_empty,
        ApplyStatus.applied => Icons.check_circle_outline,
        ApplyStatus.allotted => Icons.celebration_outlined,
        ApplyStatus.notAllotted => Icons.cancel_outlined,
        ApplyStatus.error => Icons.error_outline,
        ApplyStatus.skipped => Icons.skip_next_outlined,
      };
}
