import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../shared/enums/apply_status.dart';
import '../../domain/entities/application_entity.dart';

part 'ipo_application_model.g.dart';

/// Hive (typeId 1) + JSON model for a recorded IPO application. [status] is
/// stored as its enum name so no Hive enum adapter is required.
@HiveType(typeId: 1)
@JsonSerializable()
class IpoApplicationModel extends HiveObject {
  IpoApplicationModel({
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

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String companyShareId;

  @HiveField(2)
  final String companyName;

  @HiveField(3)
  final String accountId;

  /// ApplyStatus name, e.g. "applied".
  @HiveField(4)
  final String status;

  @HiveField(5)
  final DateTime? appliedAt;

  @HiveField(6)
  final int sharesApplied;

  @HiveField(7)
  final String? errorMessage;

  @HiveField(8)
  final DateTime? resultCheckedAt;

  factory IpoApplicationModel.fromJson(Map<String, dynamic> json) =>
      _$IpoApplicationModelFromJson(json);

  Map<String, dynamic> toJson() => _$IpoApplicationModelToJson(this);

  factory IpoApplicationModel.fromEntity(ApplicationEntity e) =>
      IpoApplicationModel(
        id: e.id,
        companyShareId: e.companyShareId,
        companyName: e.companyName,
        accountId: e.accountId,
        status: e.status.name,
        appliedAt: e.appliedAt,
        sharesApplied: e.sharesApplied,
        errorMessage: e.errorMessage,
        resultCheckedAt: e.resultCheckedAt,
      );

  ApplicationEntity toEntity() => ApplicationEntity(
        id: id,
        companyShareId: companyShareId,
        companyName: companyName,
        accountId: accountId,
        status: ApplyStatus.fromName(status),
        appliedAt: appliedAt,
        sharesApplied: sharesApplied,
        errorMessage: errorMessage,
        resultCheckedAt: resultCheckedAt,
      );
}
