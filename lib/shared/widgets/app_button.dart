import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Primary / outlined button with a built-in loading state.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.outlined = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool outlined;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              valueColor: AlwaysStoppedAnimation(AppColors.white),
            ),
          )
        : _content();

    final effectiveOnPressed = isLoading ? null : onPressed;

    if (outlined) {
      return OutlinedButton(onPressed: effectiveOnPressed, child: child);
    }
    return ElevatedButton(onPressed: effectiveOnPressed, child: child);
  }

  Widget _content() {
    if (icon == null) return Text(label);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}
