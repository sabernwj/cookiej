// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weibo_lite.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeiboLiteAdapter extends TypeAdapter<WeiboLite> {
  @override
  final typeId = 0;

  @override
  WeiboLite read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeiboLite(
      idstr: fields[5] as String,
      id: fields[0] as int,
      user: fields[3] as UserLite,
      attitudesCount: fields[9] as int,
      commentsCount: fields[8] as int,
      createdAt: fields[1] as String,
      favorited: fields[10] as bool,
      mid: fields[4] as String,
      picUrls: (fields[12] as List)?.cast<String>(),
      repostsCount: fields[7] as int,
      retweetedWeibo: fields[11] as WeiboLite,
      text: fields[2] as String,
      source: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WeiboLite obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.text)
      ..writeByte(3)
      ..write(obj.user)
      ..writeByte(4)
      ..write(obj.mid)
      ..writeByte(5)
      ..write(obj.idstr)
      ..writeByte(6)
      ..write(obj.source)
      ..writeByte(7)
      ..write(obj.repostsCount)
      ..writeByte(8)
      ..write(obj.commentsCount)
      ..writeByte(9)
      ..write(obj.attitudesCount)
      ..writeByte(10)
      ..write(obj.favorited)
      ..writeByte(11)
      ..write(obj.retweetedWeibo)
      ..writeByte(12)
      ..write(obj.picUrls);
  }
}
