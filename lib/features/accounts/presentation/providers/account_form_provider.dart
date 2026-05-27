import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/account_entity.dart';
import 'accounts_provider.dart';

/// Transient state of the add-account form submission.
class AccountFormState {
  const AccountFormState({this.isSubmitting = false, this.error});

  final bool isSubmitting;
  final String? error;

  AccountFormState copyWith({bool? isSubmitting, String? error}) =>
      AccountFormState(
        isSubmitting: isSubmitting ?? this.isSubmitting,
        error: error,
      );
}

class AccountFormNotifier extends Notifier<AccountFormState> {
  static const _uuid = Uuid();

  @override
  AccountFormState build() => const AccountFormState();

  /// Builds the entity, generates an id, and delegates to [AccountsNotifier].
  /// Returns true on success.
  Future<bool> submit({
    required String nickname,
    required String dpId,
    required String username,
    required String password,
    required String crn,
    required String boid,
    required String bankId,
  }) async {
    state = state.copyWith(isSubmitting: true, error: null);
    final account = AccountEntity(
      id: _uuid.v4(),
      nickname: nickname.trim(),
      dpId: dpId.trim(),
      username: username.trim(),
      crn: crn.trim(),
      boid: boid.trim(),
      bankId: bankId.trim(),
      createdAt: DateTime.now(),
    );

    final error = await ref
        .read(accountsProvider.notifier)
        .addAccount(account, password);

    state = state.copyWith(isSubmitting: false, error: error);
    return error == null;
  }
}

final accountFormProvider =
    NotifierProvider<AccountFormNotifier, AccountFormState>(
  AccountFormNotifier.new,
);
