import 'package:dartz/dartz.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/application_entity.dart';
import '../../domain/entities/ipo_entity.dart';
import '../../domain/repositories/ipo_repository.dart';
import '../datasources/ipo_local_datasource.dart';
import '../datasources/ipo_remote_datasource.dart';
import '../models/ipo_application_model.dart';
import '../models/ipo_listing_model.dart';

class IpoRepositoryImpl implements IpoRepository {
  IpoRepositoryImpl({
    required IpoRemoteDataSource remote,
    required IpoLocalDataSource local,
    required NetworkInfo networkInfo,
  })  : _remote = remote,
        _local = local,
        _network = networkInfo;

  final IpoRemoteDataSource _remote;
  final IpoLocalDataSource _local;
  final NetworkInfo _network;

  @override
  Future<Either<Failure, List<IpoEntity>>> getOpenIpos() async {
    if (!await _network.isConnected) return const Left(NetworkFailure());
    try {
      final models = await _remote.getOpenIpos();
      await _local.cacheIpos(models);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, bool>> isAlreadyApplied(String companyShareId) async {
    try {
      final ids = await _remote.getAppliedShareIds();
      return Right(ids.contains(companyShareId));
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, String>> submitApplication({
    required String companyShareId,
    required String crn,
    required String customerId,
    required String demat,
    required int quantity,
  }) async {
    try {
      final message = await _remote.apply(
        companyShareId: companyShareId,
        crn: crn,
        customerId: customerId,
        demat: demat,
        quantity: quantity,
      );
      return Right(message);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<ApplicationEntity>>> getApplications() async {
    try {
      final models = _local.getApplications()
        ..sort((a, b) => (b.appliedAt ?? DateTime(0))
            .compareTo(a.appliedAt ?? DateTime(0)));
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveApplication(
    ApplicationEntity application,
  ) async {
    try {
      await _local.saveApplication(IpoApplicationModel.fromEntity(application));
      return const Right(unit);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<IpoEntity>>> getCachedIpos() async {
    try {
      return Right(_local.getCachedIpos().map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> cacheIpos(List<IpoEntity> ipos) async {
    try {
      await _local
          .cacheIpos(ipos.map(IpoListingModel.fromEntity).toList());
      return const Right(unit);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
