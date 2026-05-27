// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ipo_application_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IpoApplicationModelAdapter extends TypeAdapter<IpoApplicationModel> {
  @override
  final int typeId = 1;

  @override
  IpoApplicationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IpoApplicationModel(
      id: fields[0] as String,
      companyShareId: fields[1] as String,
      companyName: fields[2] as String,
      accountId: fields[3] as String,
      status: fields[4] as String,
      appliedAt: fields[5] as DateTime?,
      sharesApplied: fields[6] as int,
      errorMessage: fields[7] as String?,
      resultCheckedAt: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, IpoApplicationModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.companyShareId)
      ..writeByte(2)
      ..write(obj.companyName)
      ..writeByte(3)
      ..write(obj.accountId)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.appliedAt)
      ..writeByte(6)
      ..write(obj.sharesApplied)
      ..writeByte(7)
      ..write(obj.errorMessage)
      ..writeByte(8)
      ..write(obj.resultCheckedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IpoApplicationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IpoApplicationModel _$IpoApplicationModelFromJson(Map<String, dynamic> json) =>
    IpoApplicationModel(
      id: json['id'] as String,
      companyShareId: json['companyShareId'] as String,
      companyName: json['companyName'] as String,
      accountId: json['accountId'] as String,
      status: json['status'] as String,
      appliedAt: json['appliedAt'] == null
          ? null
          : DateTime.parse(json['appliedAt'] as String),
      sharesApplied: (json['sharesApplied'] as num?)?.toInt() ?? 10,
      errorMessage: json['errorMessage'] as String?,
      resultCheckedAt: json['resultCheckedAt'] == null
          ? null
          : DateTime.parse(json['resultCheckedAt'] as String),
    );

Map<String, dynamic> _$IpoApplicationModelToJson(
        IpoApplicationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'companyShareId': instance.companyShareId,
      'companyName': instance.companyName,
      'accountId': instance.accountId,
      'status': instance.status,
      'appliedAt': instance.appliedAt?.toIso8601String(),
      'sharesApplied': instance.sharesApplied,
      'errorMessage': instance.errorMessage,
      'resultCheckedAt': instance.resultCheckedAt?.toIso8601String(),
    };
