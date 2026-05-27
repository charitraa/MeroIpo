// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AccountModelAdapter extends TypeAdapter<AccountModel> {
  @override
  final int typeId = 0;

  @override
  AccountModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AccountModel(
      id: fields[0] as String,
      nickname: fields[1] as String,
      dpId: fields[2] as String,
      username: fields[3] as String,
      crn: fields[4] as String,
      boid: fields[5] as String,
      bankId: fields[6] as String,
      autoApplyEnabled: fields[7] as bool,
      createdAt: fields[8] as DateTime?,
      lastAppliedAt: fields[9] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, AccountModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nickname)
      ..writeByte(2)
      ..write(obj.dpId)
      ..writeByte(3)
      ..write(obj.username)
      ..writeByte(4)
      ..write(obj.crn)
      ..writeByte(5)
      ..write(obj.boid)
      ..writeByte(6)
      ..write(obj.bankId)
      ..writeByte(7)
      ..write(obj.autoApplyEnabled)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.lastAppliedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountModel _$AccountModelFromJson(Map<String, dynamic> json) => AccountModel(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
      dpId: json['dpId'] as String,
      username: json['username'] as String,
      crn: json['crn'] as String,
      boid: json['boid'] as String,
      bankId: json['bankId'] as String,
      autoApplyEnabled: json['autoApplyEnabled'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      lastAppliedAt: json['lastAppliedAt'] == null
          ? null
          : DateTime.parse(json['lastAppliedAt'] as String),
    );

Map<String, dynamic> _$AccountModelToJson(AccountModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'dpId': instance.dpId,
      'username': instance.username,
      'crn': instance.crn,
      'boid': instance.boid,
      'bankId': instance.bankId,
      'autoApplyEnabled': instance.autoApplyEnabled,
      'createdAt': instance.createdAt?.toIso8601String(),
      'lastAppliedAt': instance.lastAppliedAt?.toIso8601String(),
    };
