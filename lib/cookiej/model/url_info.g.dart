// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'url_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UrlInfoAdapter extends TypeAdapter<UrlInfo> {
  @override
  final typeId = 2;

  @override
  UrlInfo read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UrlInfo(
      result: fields[0] as bool,
      urlShort: fields[1] as String,
      urlLong: fields[2] as String,
      transcode: fields[3] as int,
      description: fields[4] as String,
      annotations: (fields[5] as List)?.cast<Annotations>(),
      type: fields[6] as int,
      title: fields[7] as String,
      lastModified: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UrlInfo obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.result)
      ..writeByte(1)
      ..write(obj.urlShort)
      ..writeByte(2)
      ..write(obj.urlLong)
      ..writeByte(3)
      ..write(obj.transcode)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.annotations)
      ..writeByte(6)
      ..write(obj.type)
      ..writeByte(7)
      ..write(obj.title)
      ..writeByte(8)
      ..write(obj.lastModified);
  }
}
