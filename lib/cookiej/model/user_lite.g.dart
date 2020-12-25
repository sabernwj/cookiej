// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_lite.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserLiteAdapter extends TypeAdapter<UserLite> {
  @override
  final int typeId = 1;

  @override
  UserLite read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserLite(
      id: fields[0] as int,
      idstr: fields[1] as String,
      screenName: fields[2] as String,
      name: fields[3] as String,
      iconId: fields[4] as String,
      description: fields[5] as String,
      favouritesCount: fields[11] as int,
      followersCount: fields[6] as int,
      friendsCount: fields[7] as int,
      pagefriendsCount: fields[8] as int,
      statusesCount: fields[9] as int,
      videoStatusCount: fields[10] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UserLite obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.idstr)
      ..writeByte(2)
      ..write(obj.screenName)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.iconId)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.followersCount)
      ..writeByte(7)
      ..write(obj.friendsCount)
      ..writeByte(8)
      ..write(obj.pagefriendsCount)
      ..writeByte(9)
      ..write(obj.statusesCount)
      ..writeByte(10)
      ..write(obj.videoStatusCount)
      ..writeByte(11)
      ..write(obj.favouritesCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserLiteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
