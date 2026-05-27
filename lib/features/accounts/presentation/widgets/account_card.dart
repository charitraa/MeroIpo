import 'package:flutter/material.dart';

import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/account_entity.dart';

/// Compact card for one account with an auto-apply toggle and delete action.
class AccountCard extends StatelessWidget {
  const AccountCard({
    super.key,
    required this.account,
    required this.onToggleAutoApply,
    required this.onDelete,
  });

  final AccountEntity account;
  final ValueChanged<bool> onToggleAutoApply;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.card(context),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: context.colors.primary.withValues(alpha: 0.15),
            child: Text(
              account.nickname.initials,
              style: TextStyle(
                color: context.colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.nickname,
                  style: context.textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${account.username} • DP ${account.dpId}',
                  style: context.textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            children: [
              Switch(
                value: account.autoApplyEnabled,
                onChanged: onToggleAutoApply,
              ),
              Text('Auto', style: context.textTheme.labelSmall),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            color: context.colors.error,
            onPressed: onDelete,
            tooltip: 'Delete account',
          ),
        ],
      ),
    );
  }
}
