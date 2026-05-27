import 'package:dartz/dartz.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/auth_token_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required SecureStorage secureStorage,
    required TokenStore tokenStore,
  })  : _remote = remote,
        _secure = secureStorage,
        _tokenStore = tokenStore;

  final AuthRemoteDataSource _remote;
  final SecureStorage _secure;
  final TokenStore _tokenStore;

  @override
  Future<Either<Failure, AuthTokenEntity>> login({
    required String accountId,
    required String dpId,
    required String username,
    required String password,
  }) async {
    try {
      final token = await _remote.login(
        dpId: dpId,
        username: username,
        password: password,
      );
      // Make the token active for subsequent requests and persist it.
      _tokenStore.token = token;
      await _secure.saveToken(accountId, token);
      return Right(AuthTokenEntity(token: token, issuedAt: DateTime.now()));
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
