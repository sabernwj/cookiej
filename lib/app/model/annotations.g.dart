// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'annotations.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AnnotationsAdapter extends TypeAdapter<Annotations> {
  @override
  final int typeId = 7;

  @override
  Annotations read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Annotations(
      uuidstr: fields[0] as String,
      objectType: fields[1] as String,
      activateStatus: fields[2] as String,
      safeStatus: fields[3] as int,
      objectId: fields[4] as String,
      uuid: fields[5] as int,
      actStatus: fields[6] as String,
      objectDomainId: fields[7] as String,
      containerid: fields[8] as String,
      showStatus: fields[9] as String,
      lastModified: fields[10] as String,
      timestamp: fields[11] as int,
      object: fields[12] as DataObject,
    );
  }

  @override
  void write(BinaryWriter writer, Annotations obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.uuidstr)
      ..writeByte(1)
      ..write(obj.objectType)
      ..writeByte(2)
      ..write(obj.activateStatus)
      ..writeByte(3)
      ..write(obj.safeStatus)
      ..writeByte(4)
      ..write(obj.objectId)
      ..writeByte(5)
      ..write(obj.uuid)
      ..writeByte(6)
      ..write(obj.actStatus)
      ..writeByte(7)
      ..write(obj.objectDomainId)
      ..writeByte(8)
      ..write(obj.containerid)
      ..writeByte(9)
      ..write(obj.showStatus)
      ..writeByte(10)
      ..write(obj.lastModified)
      ..writeByte(11)
      ..write(obj.timestamp)
      ..writeByte(12)
      ..write(obj.object);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnnotationsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
