import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../accounts/presentation/providers/accounts_provider.dart';
import '../../../ipo/domain/entities/application_entity.dart';
import '../../../ipo/presentation/providers/open_ipos_provider.dart';

/// A history row: an application joined with its account nickname.
class HistoryItemData {
  const HistoryItemData({required this.application, required this.accountLabel});

  final ApplicationEntity application;
  final String accountLabel;
}

/// Application history (newest first), with account nicknames resolved.
final historyProvider = Provider<List<HistoryItemData>>((ref) {
  final apps = ref.watch(applicationsProvider).valueOrNull ?? const [];
  final accounts = ref.watch(accountsProvider).valueOrNull ?? const [];
  final byId = {for (final a in accounts) a.id: a.nickname};

  return apps
      .map((app) => HistoryItemData(
            application: app,
            accountLabel: byId[app.accountId] ?? 'Unknown account',
          ))
      .toList();
});
