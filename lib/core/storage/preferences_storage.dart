import 'package:shared_preferences/shared_preferences.dart';

import '../constants/storage_keys.dart';

/// Non-sensitive app settings backed by SharedPreferences.
class PreferencesStorage {
  PreferencesStorage(this._prefs);

  final SharedPreferences _prefs;

  // Theme: 'light' | 'dark' | 'system'.
  String get themeMode => _prefs.getString(StorageKeys.themeMode) ?? 'system';
  Future<void> setThemeMode(String mode) =>
      _prefs.setString(StorageKeys.themeMode, mode);

  bool get biometricEnabled =>
      _prefs.getBool(StorageKeys.biometricEnabled) ?? false;
  Future<void> setBiometricEnabled(bool v) =>
      _prefs.setBool(StorageKeys.biometricEnabled, v);

  bool get autoApplyGlobalEnabled =>
      _prefs.getBool(StorageKeys.autoApplyGlobalEnabled) ?? true;
  Future<void> setAutoApplyGlobalEnabled(bool v) =>
      _prefs.setBool(StorageKeys.autoApplyGlobalEnabled, v);

  String? get fcmToken => _prefs.getString(StorageKeys.fcmToken);
  Future<void> setFcmToken(String token) =>
      _prefs.setString(StorageKeys.fcmToken, token);

  DateTime? get lastPollAt {
    final ms = _prefs.getInt(StorageKeys.lastPollAt);
    return ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);
  }

  Future<void> setLastPollAt(DateTime dt) =>
      _prefs.setInt(StorageKeys.lastPollAt, dt.millisecondsSinceEpoch);
}
