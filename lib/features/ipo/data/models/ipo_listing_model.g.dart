// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ipo_listing_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IpoListingModelAdapter extends TypeAdapter<IpoListingModel> {
  @override
  final int typeId = 2;

  @override
  IpoListingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IpoListingModel(
      companyShareId: fields[0] as String,
      companyName: fields[1] as String,
      shareTypeName: fields[2] as String,
      openDate: fields[3] as DateTime,
      closeDate: fields[4] as DateTime,
      minUnit: fields[5] as int,
      maxUnit: fields[6] as int,
      isOpen: fields[7] as bool,
      scrip: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, IpoListingModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.companyShareId)
      ..writeByte(1)
      ..write(obj.companyName)
      ..writeByte(2)
      ..write(obj.shareTypeName)
      ..writeByte(3)
      ..write(obj.openDate)
      ..writeByte(4)
      ..write(obj.closeDate)
      ..writeByte(5)
      ..write(obj.minUnit)
      ..writeByte(6)
      ..write(obj.maxUnit)
      ..writeByte(7)
      ..write(obj.isOpen)
      ..writeByte(8)
      ..write(obj.scrip);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IpoListingModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IpoListingModel _$IpoListingModelFromJson(Map<String, dynamic> json) =>
    IpoListingModel(
      companyShareId: json['companyShareId'] as String,
      companyName: json['companyName'] as String,
      shareTypeName: json['shareTypeName'] as String,
      openDate: DateTime.parse(json['openDate'] as String),
      closeDate: DateTime.parse(json['closeDate'] as String),
      minUnit: (json['minUnit'] as num?)?.toInt() ?? 10,
      maxUnit: (json['maxUnit'] as num?)?.toInt() ?? 0,
      isOpen: json['isOpen'] as bool? ?? true,
      scrip: json['scrip'] as String?,
    );

Map<String, dynamic> _$IpoListingModelToJson(IpoListingModel instance) =>
    <String, dynamic>{
      'companyShareId': instance.companyShareId,
      'companyName': instance.companyName,
      'shareTypeName': instance.shareTypeName,
      'openDate': instance.openDate.toIso8601String(),
      'closeDate': instance.closeDate.toIso8601String(),
      'minUnit': instance.minUnit,
      'maxUnit': instance.maxUnit,
      'isOpen': instance.isOpen,
      'scrip': instance.scrip,
    };
