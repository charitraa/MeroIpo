import 'package:equatable/equatable.dart';

import '../../../../shared/enums/apply_status.dart';

/// One IPO application by a single account.
class ApplicationEntity extends Equatable {
  const ApplicationEntity({
    required this.id,
    required this.companyShareId,
    required this.companyName,
    required this.accountId,
    required this.status,
    this.appliedAt,
    this.sharesApplied = 10,
    this.errorMessage,
    this.resultCheckedAt,
  });

  final String id; // UUID — local
  final String companyShareId;
  final String companyName;
  final String accountId; // FK → AccountEntity.id
  final ApplyStatus status;
  final DateTime? appliedAt;
  final int sharesApplied;
  final String? errorMessage;
  final DateTime? resultCheckedAt;

  ApplicationEntity copyWith({
    ApplyStatus? status,
    DateTime? appliedAt,
    int? sharesApplied,
    String? errorMessage,
    DateTime? resultCheckedAt,
  }) {
    return ApplicationEntity(
      id: id,
      companyShareId: companyShareId,
      companyName: companyName,
      accountId: accountId,
      status: status ?? this.status,
      appliedAt: appliedAt ?? this.appliedAt,
      sharesApplied: sharesApplied ?? this.sharesApplied,
      errorMessage: errorMessage,
      resultCheckedAt: resultCheckedAt ?? this.resultCheckedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        companyShareId,
        companyName,
        accountId,
        status,
        appliedAt,
        sharesApplied,
        errorMessage,
        resultCheckedAt,
      ];
}
