// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AccessAdapter extends TypeAdapter<Access> {
  @override
  final int typeId = 0;

  @override
  Access read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Access(
      uid: fields[0] as String,
      accessToken: fields[1] as String,
      cookieStr: fields[2] as String,
    )
      ..groupIdNames = (fields[3] as List)
          ?.map((dynamic e) => (e as Map)?.cast<String, String>())
          ?.toList()
      ..accessInvalid = fields[4] as bool;
  }

  @override
  void write(BinaryWriter writer, Access obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.accessToken)
      ..writeByte(2)
      ..write(obj.cookieStr)
      ..writeByte(3)
      ..write(obj.groupIdNames)
      ..writeByte(4)
      ..write(obj.accessInvalid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccessAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
