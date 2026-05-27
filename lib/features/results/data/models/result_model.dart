/// Parsed `GET /report/{companyShareId}/` allotment response for one account.
/// Not persisted to Hive — derived live or folded into the application record.
class ResultModel {
  const ResultModel({
    required this.companyShareId,
    required this.allotted,
    this.allottedQuantity = 0,
    this.message,
  });

  final String companyShareId;
  final bool allotted;
  final int allottedQuantity;
  final String? message;

  factory ResultModel.fromApi(String companyShareId, dynamic data) {
    final map = data is Map ? data : const {};
    final allotted = map['alloted'] == true ||
        map['allotted'] == true ||
        (map['allottedQuantity'] is num &&
            (map['allottedQuantity'] as num) > 0);
    return ResultModel(
      companyShareId: companyShareId,
      allotted: allotted,
      allottedQuantity:
          int.tryParse('${map['allottedQuantity'] ?? map['alloted'] ?? 0}') ??
              0,
      message: map['message']?.toString(),
    );
  }
}
