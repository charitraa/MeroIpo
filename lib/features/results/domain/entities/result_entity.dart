import 'package:equatable/equatable.dart';

import '../../../../shared/enums/apply_status.dart';

/// Allotment outcome for one account's application.
class ResultEntity extends Equatable {
  const ResultEntity({
    required this.applicationId,
    required this.companyShareId,
    required this.companyName,
    required this.accountId,
    required this.status,
    this.allottedQuantity = 0,
    this.checkedAt,
  });

  final String applicationId;
  final String companyShareId;
  final String companyName;
  final String accountId;
  final ApplyStatus status; // allotted / notAllotted / applied (pending result)
  final int allottedQuantity;
  final DateTime? checkedAt;

  bool get isAllotted => status == ApplyStatus.allotted;

  @override
  List<Object?> get props => [
        applicationId,
        companyShareId,
        companyName,
        accountId,
        status,
        allottedQuantity,
        checkedAt,
      ];
}
