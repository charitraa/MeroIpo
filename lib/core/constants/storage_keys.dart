/// Centralised keys for Hive boxes and secure storage. Never inline these.
class StorageKeys {
  StorageKeys._();

  // Hive boxes.
  static const String accountsBox = 'accounts_box';
  static const String applicationsBox = 'applications_box';
  static const String ipoListingsBox = 'ipo_listings_box';

  // SharedPreferences keys (non-sensitive settings).
  static const String themeMode = 'pref_theme_mode';
  static const String biometricEnabled = 'pref_biometric_enabled';
  static const String autoApplyGlobalEnabled = 'pref_auto_apply_global';
  static const String fcmToken = 'pref_fcm_token';
  static const String lastPollAt = 'pref_last_poll_at';

  // Secure storage key builders (sensitive).
  static String password(String accountId) => 'pwd_$accountId';
  static String token(String accountId) => 'token_$accountId';
}
