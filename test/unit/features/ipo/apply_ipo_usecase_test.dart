import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ipo/core/errors/failure.dart';
import 'package:ipo/features/ipo/domain/entities/application_entity.dart';
import 'package:ipo/features/ipo/domain/entities/ipo_entity.dart';
import 'package:ipo/features/ipo/domain/repositories/ipo_repository.dart';
import 'package:ipo/features/ipo/domain/usecases/apply_ipo_usecase.dart';
import 'package:ipo/shared/enums/apply_status.dart';

/// Hand-written fake (no codegen) that records submissions and lets tests
/// control the "already applied" answer.
class _FakeIpoRepository implements IpoRepository {
  bool alreadyApplied = false;
  bool submitFails = false;
  int submitCalls = 0;
  final List<ApplicationEntity> saved = [];

  @override
  Future<Either<Failure, bool>> isAlreadyApplied(String companyShareId) async =>
      Right(alreadyApplied);

  @override
  Future<Either<Failure, String>> submitApplication({
    required String companyShareId,
    required String crn,
    required String customerId,
    required String demat,
    required int quantity,
  }) async {
    submitCalls++;
    return submitFails
        ? const Left(ServerFailure('boom'))
        : const Right('Applied');
  }

  @override
  Future<Either<Failure, Unit>> saveApplication(ApplicationEntity app) async {
    saved.add(app);
    return const Right(unit);
  }

  @override
  Future<Either<Failure, List<ApplicationEntity>>> getApplications() async =>
      Right(saved);

  @override
  Future<Either<Failure, List<IpoEntity>>> getOpenIpos() async =>
      const Right([]);

  @override
  Future<Either<Failure, List<IpoEntity>>> getCachedIpos() async =>
      const Right([]);

  @override
  Future<Either<Failure, Unit>> cacheIpos(List<IpoEntity> ipos) async =>
      const Right(unit);
}

void main() {
  group('ApplyIpoUsecase', () {
    late _FakeIpoRepository repo;
    late ApplyIpoUsecase usecase;

    setUp(() {
      repo = _FakeIpoRepository();
      usecase = ApplyIpoUsecase(repo);
    });

    Future<Either<Failure, ApplicationEntity>> run() => usecase.call(
          companyShareId: '1',
          companyName: 'Test Co',
          accountId: 'acc-1',
          crn: 'CRN1',
          customerId: 'bank-1',
          demat: '1234567890123456',
          quantity: 10,
        );

    test('submits and records an applied outcome', () async {
      final result = await run();

      expect(repo.submitCalls, 1);
      expect(result.isRight(), isTrue);
      result.fold((_) => fail('expected Right'), (e) {
        expect(e.status, ApplyStatus.applied);
        expect(e.sharesApplied, 10);
      });
      expect(repo.saved.single.status, ApplyStatus.applied);
    });

    test('skips submission when already applied', () async {
      repo.alreadyApplied = true;
      final result = await run();

      expect(repo.submitCalls, 0);
      result.fold((_) => fail('expected Right'),
          (e) => expect(e.status, ApplyStatus.applied));
    });

    test('records an error outcome when submission fails', () async {
      repo.submitFails = true;
      final result = await run();

      result.fold((_) => fail('expected Right with error status'), (e) {
        expect(e.status, ApplyStatus.error);
        expect(e.errorMessage, 'boom');
      });
    });
  });
}
