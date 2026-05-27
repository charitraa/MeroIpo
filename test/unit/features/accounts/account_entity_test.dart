import 'package:flutter_test/flutter_test.dart';
import 'package:ipo/core/utils/validators.dart';
import 'package:ipo/features/accounts/domain/entities/account_entity.dart';

void main() {
  group('AccountEntity', () {
    const account = AccountEntity(
      id: 'id-1',
      nickname: 'Hari',
      dpId: '13200',
      username: 'hari99',
      crn: 'CRN123',
      boid: '1234567890123456',
      bankId: 'bank-1',
    );

    test('copyWith overrides only the given fields', () {
      final updated = account.copyWith(autoApplyEnabled: false);
      expect(updated.autoApplyEnabled, isFalse);
      expect(updated.id, account.id);
      expect(updated.nickname, account.nickname);
    });

    test('value equality ignores identity', () {
      expect(account, account.copyWith());
    });
  });

  group('Validators', () {
    test('boid requires exactly 16 digits', () {
      expect(Validators.boid('1234567890123456'), isNull);
      expect(Validators.boid('123'), isNotNull);
      expect(Validators.boid('abcd567890123456'), isNotNull);
    });

    test('dpId accepts 3-7 digits', () {
      expect(Validators.dpId('13200'), isNull);
      expect(Validators.dpId('1'), isNotNull);
      expect(Validators.dpId('abc'), isNotNull);
    });
  });
}
