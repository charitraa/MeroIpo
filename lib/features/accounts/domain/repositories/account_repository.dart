import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/account_entity.dart';

/// Account CRUD. Implementations persist non-secret fields in Hive and the
/// password in secure storage.
abstract interface class AccountRepository {
  Future<Either<Failure, List<AccountEntity>>> getAccounts();

  Future<Either<Failure, AccountEntity>> getAccount(String id);

  /// Adds an account and stores its [password] securely.
  Future<Either<Failure, AccountEntity>> addAccount(
    AccountEntity account,
    String password,
  );

  /// Updates non-secret fields; pass [password] to rotate the stored secret.
  Future<Either<Failure, AccountEntity>> updateAccount(
    AccountEntity account, {
    String? password,
  });

  Future<Either<Failure, Unit>> deleteAccount(String id);

  Future<Either<Failure, AccountEntity>> toggleAutoApply(String id, bool enabled);

  /// Reads the securely stored password for an account (used at login time).
  Future<Either<Failure, String>> getPassword(String id);
}
