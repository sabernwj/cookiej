// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalStateAdapter extends TypeAdapter<LocalState> {
  @override
  final int typeId = 6;

  @override
  LocalState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalState(
      fields[0] as String,
      isDarkMode: fields[1] as bool,
      themeName: fields[3] as String,
      isDarkAuto: fields[2] as bool,
      userInfo: fields[4] as UserLite,
      weiboTypes: (fields[5] as List)?.cast<String>(),
      weiboTypesIndex: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, LocalState obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.isDarkMode)
      ..writeByte(2)
      ..write(obj.isDarkAuto)
      ..writeByte(3)
      ..write(obj.themeName)
      ..writeByte(4)
      ..write(obj.userInfo)
      ..writeByte(5)
      ..write(obj.weiboTypes)
      ..writeByte(6)
      ..write(obj.weiboTypesIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
