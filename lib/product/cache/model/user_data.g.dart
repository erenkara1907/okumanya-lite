// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDataAdapter extends TypeAdapter<UserData> {
  @override
  final int typeId = 0;

  @override
  UserData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserData(
      id: fields[0] as String,
      nickName: fields[1] as String,
      originalNickName: fields[2] as String,
      schoolName: fields[3] as String,
      city: fields[4] as TurkishCity,
      grade: fields[5] as SchoolGrade,
      createdAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UserData obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nickName)
      ..writeByte(2)
      ..write(obj.originalNickName)
      ..writeByte(3)
      ..write(obj.schoolName)
      ..writeByte(4)
      ..write(obj.city)
      ..writeByte(5)
      ..write(obj.grade)
      ..writeByte(6)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
