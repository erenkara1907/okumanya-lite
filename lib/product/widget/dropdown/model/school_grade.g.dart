// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'school_grade.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SchoolGradeAdapter extends TypeAdapter<SchoolGrade> {
  @override
  final int typeId = 2;

  @override
  SchoolGrade read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SchoolGrade(
      id: fields[0] as String,
      name: fields[1] as String,
      level: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SchoolGrade obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.level);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SchoolGradeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
