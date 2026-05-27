import 'package:dartz/dartz.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/account_entity.dart';
import '../../domain/repositories/account_repository.dart';
import '../datasources/account_local_datasource.dart';
import '../models/account_model.dart';

class AccountRepositoryImpl implements AccountRepository {
  AccountRepositoryImpl(this._local);

  final AccountLocalDataSource _local;

  @override
  Future<Either<Failure, List<AccountEntity>>> getAccounts() async {
    try {
      final models = _local.getAll()..sort(_byCreatedAt);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, AccountEntity>> getAccount(String id) async {
    try {
      return Right(_local.getById(id).toEntity());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, AccountEntity>> addAccount(
    AccountEntity account,
    String password,
  ) async {
    try {
      final model = AccountModel.fromEntity(
        account.copyWith(createdAt: account.createdAt ?? DateTime.now()),
      );
      await _local.put(model, password: password);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, AccountEntity>> updateAccount(
    AccountEntity account, {
    String? password,
  }) async {
    try {
      final model = AccountModel.fromEntity(account);
      await _local.put(model, password: password);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAccount(String id) async {
    try {
      await _local.delete(id);
      return const Right(unit);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, AccountEntity>> toggleAutoApply(
    String id,
    bool enabled,
  ) async {
    try {
      final current = _local.getById(id).toEntity();
      final updated = current.copyWith(autoApplyEnabled: enabled);
      await _local.put(AccountModel.fromEntity(updated));
      return Right(updated);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, String>> getPassword(String id) async {
    try {
      return Right(await _local.readPassword(id));
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  int _byCreatedAt(AccountModel a, AccountModel b) =>
      (a.createdAt ?? DateTime(0)).compareTo(b.createdAt ?? DateTime(0));
}
