import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utils/date_utils.dart';
import '../../domain/entities/ipo_entity.dart';

part 'ipo_listing_model.g.dart';

/// Hive (typeId 2) + JSON model for a listed IPO. [fromJson]/[toJson] handle our
/// normalised cache shape; [fromApi] parses MeroShare's raw response, whose
/// field names and numeric ids differ.
@HiveType(typeId: 2)
@JsonSerializable()
class IpoListingModel extends HiveObject {
  IpoListingModel({
    required this.companyShareId,
    required this.companyName,
    required this.shareTypeName,
    required this.openDate,
    required this.closeDate,
    this.minUnit = 10,
    this.maxUnit = 0,
    this.isOpen = true,
    this.scrip,
  });

  @HiveField(0)
  final String companyShareId;

  @HiveField(1)
  final String companyName;

  @HiveField(2)
  final String shareTypeName;

  @HiveField(3)
  final DateTime openDate;

  @HiveField(4)
  final DateTime closeDate;

  @HiveField(5)
  final int minUnit;

  @HiveField(6)
  final int maxUnit;

  @HiveField(7)
  final bool isOpen;

  @HiveField(8)
  final String? scrip;

  factory IpoListingModel.fromJson(Map<String, dynamic> json) =>
      _$IpoListingModelFromJson(json);

  Map<String, dynamic> toJson() => _$IpoListingModelToJson(this);

  /// Parses one item from `GET /meroShare/applicable/`.
  factory IpoListingModel.fromApi(Map<String, dynamic> json) {
    final open = AppDateUtils.tryParse(json['issueOpenDate']?.toString()) ??
        DateTime.now();
    final close = AppDateUtils.tryParse(json['issueCloseDate']?.toString()) ??
        DateTime.now().add(const Duration(days: 1));
    return IpoListingModel(
      companyShareId: json['companyShareId']?.toString() ?? '',
      companyName: (json['companyName'] ?? json['scrip'] ?? 'Unknown').toString(),
      shareTypeName:
          (json['shareGroupName'] ?? json['shareTypeName'] ?? '').toString(),
      openDate: open,
      closeDate: close,
      minUnit: int.tryParse(json['minUnit']?.toString() ?? '') ?? 10,
      maxUnit: int.tryParse(json['maxUnit']?.toString() ?? '') ?? 0,
      isOpen: AppDateUtils.isOpenNow(open, close),
      scrip: json['scrip']?.toString(),
    );
  }

  factory IpoListingModel.fromEntity(IpoEntity e) => IpoListingModel(
        companyShareId: e.companyShareId,
        companyName: e.companyName,
        shareTypeName: e.shareTypeName,
        openDate: e.openDate,
        closeDate: e.closeDate,
        minUnit: e.minUnit,
        maxUnit: e.maxUnit,
        isOpen: e.isOpen,
        scrip: e.scrip,
      );

  IpoEntity toEntity() => IpoEntity(
        companyShareId: companyShareId,
        companyName: companyName,
        shareTypeName: shareTypeName,
        openDate: openDate,
        closeDate: closeDate,
        minUnit: minUnit,
        maxUnit: maxUnit,
        isOpen: isOpen,
        scrip: scrip,
      );
}
