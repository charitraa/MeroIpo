import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/account_entity.dart';

part 'account_model.g.dart';

/// Hive (typeId 0) + JSON persistence model for an account.
/// Never holds the password — that is in secure storage.
@HiveType(typeId: 0)
@JsonSerializable()
class AccountModel extends HiveObject {
  AccountModel({
    required this.id,
    required this.nickname,
    required this.dpId,
    required this.username,
    required this.crn,
    required this.boid,
    required this.bankId,
    this.autoApplyEnabled = true,
    this.createdAt,
    this.lastAppliedAt,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String nickname;

  @HiveField(2)
  final String dpId;

  @HiveField(3)
  final String username;

  @HiveField(4)
  final String crn;

  @HiveField(5)
  final String boid;

  @HiveField(6)
  final String bankId;

  @HiveField(7)
  final bool autoApplyEnabled;

  @HiveField(8)
  final DateTime? createdAt;

  @HiveField(9)
  final DateTime? lastAppliedAt;

  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountModelToJson(this);

  factory AccountModel.fromEntity(AccountEntity e) => AccountModel(
        id: e.id,
        nickname: e.nickname,
        dpId: e.dpId,
        username: e.username,
        crn: e.crn,
        boid: e.boid,
        bankId: e.bankId,
        autoApplyEnabled: e.autoApplyEnabled,
        createdAt: e.createdAt,
        lastAppliedAt: e.lastAppliedAt,
      );

  AccountEntity toEntity() => AccountEntity(
        id: id,
        nickname: nickname,
        dpId: dpId,
        username: username,
        crn: crn,
        boid: boid,
        bankId: bankId,
        autoApplyEnabled: autoApplyEnabled,
        createdAt: createdAt,
        lastAppliedAt: lastAppliedAt,
      );
}
