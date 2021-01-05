// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emotion.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmotionAdapter extends TypeAdapter<Emotion> {
  @override
  final int typeId = 9;

  @override
  Emotion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Emotion(
      phrase: fields[0] as String,
      url: fields[1] as String,
      category: fields[2] as String,
      hot: fields[3] as bool,
      common: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Emotion obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.phrase)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.hot)
      ..writeByte(4)
      ..write(obj.common);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmotionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
