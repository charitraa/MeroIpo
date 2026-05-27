import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/storage_keys.dart';

/// Wrapper over flutter_secure_storage for credentials and tokens.
///
/// This is the ONLY place passwords and tokens are persisted. Backed by the
/// Android Keystore / iOS Keychain.
class SecureStorage {
  SecureStorage([FlutterSecureStorage? storage])
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock,
              ),
            );

  final FlutterSecureStorage _storage;

  // Passwords.
  Future<void> savePassword(String accountId, String password) =>
      _storage.write(key: StorageKeys.password(accountId), value: password);

  Future<String?> readPassword(String accountId) =>
      _storage.read(key: StorageKeys.password(accountId));

  Future<void> deletePassword(String accountId) =>
      _storage.delete(key: StorageKeys.password(accountId));

  // Tokens.
  Future<void> saveToken(String accountId, String token) =>
      _storage.write(key: StorageKeys.token(accountId), value: token);

  Future<String?> readToken(String accountId) =>
      _storage.read(key: StorageKeys.token(accountId));

  Future<void> deleteToken(String accountId) =>
      _storage.delete(key: StorageKeys.token(accountId));

  /// Remove every secret tied to an account (called on account delete).
  Future<void> purgeAccount(String accountId) async {
    await deletePassword(accountId);
    await deleteToken(accountId);
  }
}
