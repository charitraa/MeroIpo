import 'package:hive/hive.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/account_model.dart';

/// Persists accounts to a Hive box and passwords to secure storage.
class AccountLocalDataSource {
  AccountLocalDataSource({
    required Box<AccountModel> box,
    required SecureStorage secureStorage,
  })  : _box = box,
        _secure = secureStorage;

  final Box<AccountModel> _box;
  final SecureStorage _secure;

  List<AccountModel> getAll() {
    try {
      return _box.values.toList(growable: false);
    } catch (e) {
      throw CacheException('Failed to read accounts: $e');
    }
  }

  AccountModel getById(String id) {
    final model = _box.get(id);
    if (model == null) throw const NotFoundException('Account not found');
    return model;
  }

  Future<void> put(AccountModel model, {String? password}) async {
    try {
      await _box.put(model.id, model);
      if (password != null) {
        await _secure.savePassword(model.id, password);
      }
    } catch (e) {
      throw CacheException('Failed to save account: $e');
    }
  }

  Future<void> delete(String id) async {
    try {
      await _box.delete(id);
      await _secure.purgeAccount(id);
    } catch (e) {
      throw CacheException('Failed to delete account: $e');
    }
  }

  Future<String> readPassword(String id) async {
    final pwd = await _secure.readPassword(id);
    if (pwd == null) {
      throw const AuthException('No saved password for this account');
    }
    return pwd;
  }
}
