// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'url_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UrlInfoAdapter extends TypeAdapter<UrlInfo> {
  @override
  final int typeId = 5;

  @override
  UrlInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UrlInfo(
      result: fields[0] as bool,
      urlShort: fields[1] as String,
      urlLong: fields[2] as String,
      description: fields[3] as String,
      annotations: (fields[4] as List)?.cast<Annotations>(),
      type: fields[5] as int,
      title: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UrlInfo obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.result)
      ..writeByte(1)
      ..write(obj.urlShort)
      ..writeByte(2)
      ..write(obj.urlLong)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.annotations)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.title);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UrlInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
