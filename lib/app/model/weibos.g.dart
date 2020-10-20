// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weibos.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeibosAdapter extends TypeAdapter<Weibos> {
  @override
  final typeId = 4;

  @override
  Weibos read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Weibos(
      statuses: (fields[0] as List)?.cast<WeiboLite>(),
      sinceId: fields[1] as int,
      maxId: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Weibos obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.statuses)
      ..writeByte(1)
      ..write(obj.sinceId)
      ..writeByte(2)
      ..write(obj.maxId);
  }
}
