import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';

/// Reusable [BoxDecoration] presets.
class AppDecorations {
  AppDecorations._();

  static BoxDecoration card(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: dark ? AppColors.darkSurface : AppColors.lightSurface,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      border: Border.all(
        color: dark ? AppColors.darkBorder : AppColors.lightBorder,
      ),
    );
  }

  static BoxDecoration banner = BoxDecoration(
    gradient: const LinearGradient(
      colors: [AppColors.primary, AppColors.secondary],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
  );

  static BoxDecoration pill(Color color) => BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      );
}
