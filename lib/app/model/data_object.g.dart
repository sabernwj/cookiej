// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_object.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataObjectAdapter extends TypeAdapter<DataObject> {
  @override
  final int typeId = 8;

  @override
  DataObject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataObject(
      objectType: fields[0] as String,
      targetUrl: fields[1] as String,
      id: fields[2] as String,
      displayName: fields[3] as String,
      url: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DataObject obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.objectType)
      ..writeByte(1)
      ..write(obj.targetUrl)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.displayName)
      ..writeByte(4)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataObjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
