import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../accounts/domain/entities/account_entity.dart';

/// One-line account status used in the dashboard's accounts overview.
class AccountStatusRow extends StatelessWidget {
  const AccountStatusRow({super.key, required this.account});

  final AccountEntity account;

  @override
  Widget build(BuildContext context) {
    final enabled = account.autoApplyEnabled;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: context.colors.primary.withValues(alpha: 0.15),
            child: Text(
              account.nickname.initials,
              style: TextStyle(
                fontSize: 12,
                color: context.colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              account.nickname,
              style: context.textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(
            enabled ? Icons.check_circle : Icons.pause_circle_outline,
            size: 18,
            color: enabled ? context.colors.primary : context.theme.disabledColor,
          ),
          const SizedBox(width: 4),
          Text(
            enabled ? 'Auto' : 'Off',
            style: context.textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}
