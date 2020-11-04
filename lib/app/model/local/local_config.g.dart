// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalConfigAdapter extends TypeAdapter<LocalConfig> {
  @override
  final int typeId = 2;

  @override
  LocalConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalConfig()
      ..currentUserId = fields[0] as String
      ..loginUsers = (fields[1] as List)?.cast<String>()
      ..isDarkMode = fields[2] as bool
      ..fontName = fields[3] as String
      ..themeName = fields[4] as String
      ..i18nName = fields[5] as String
      ..isDarkModeAuto = fields[6] as bool
      ..filterWords = (fields[7] as List)?.cast<String>()
      ..isFilterWeibo = fields[8] as bool
      ..isFilterComment = fields[9] as bool
      ..isNoPictureMode = fields[10] as bool
      ..useInternalBrowser = fields[11] as bool;
  }

  @override
  void write(BinaryWriter writer, LocalConfig obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.currentUserId)
      ..writeByte(1)
      ..write(obj.loginUsers)
      ..writeByte(2)
      ..write(obj.isDarkMode)
      ..writeByte(3)
      ..write(obj.fontName)
      ..writeByte(4)
      ..write(obj.themeName)
      ..writeByte(5)
      ..write(obj.i18nName)
      ..writeByte(6)
      ..write(obj.isDarkModeAuto)
      ..writeByte(7)
      ..write(obj.filterWords)
      ..writeByte(8)
      ..write(obj.isFilterWeibo)
      ..writeByte(9)
      ..write(obj.isFilterComment)
      ..writeByte(10)
      ..write(obj.isNoPictureMode)
      ..writeByte(11)
      ..write(obj.useInternalBrowser);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
