import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/settings/presentation/providers/settings_provider.dart';
import 'route_names.dart';

/// App-level lock state. Unlocked immediately when biometric lock is off;
/// otherwise starts locked until the user authenticates.
class AppLockNotifier extends Notifier<bool> {
  @override
  bool build() {
    final biometric = ref.watch(settingsProvider).biometricEnabled;
    return !biometric; // unlocked when no biometric is required
  }

  void unlock() => state = true;
  void lock() => state = false;
}

final appLockProvider = NotifierProvider<AppLockNotifier, bool>(
  AppLockNotifier.new,
);

/// Redirect logic for the GoRouter. Returns the path to redirect to, or null.
String? lockRedirect({required bool isUnlocked, required String location}) {
  final atLock = location == RouteNames.lockPath;
  if (!isUnlocked && !atLock) return RouteNames.lockPath;
  if (isUnlocked && atLock) return RouteNames.dashboardPath;
  return null;
}
