import 'package:flutter/material.dart';

import '../../../../shared/widgets/confirmation_dialog.dart';
import '../../domain/entities/account_entity.dart';

/// Confirms deletion of an account (and its stored credentials).
class DeleteAccountDialog {
  const DeleteAccountDialog._();

  static Future<bool> show(BuildContext context, AccountEntity account) {
    return ConfirmationDialog.show(
      context,
      title: 'Delete account?',
      message:
          'This removes "${account.nickname}" and its saved password from this '
          'device. This cannot be undone.',
      confirmLabel: 'Delete',
      isDestructive: true,
    );
  }
}
