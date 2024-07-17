// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LeaveModelAdapter extends TypeAdapter<LeaveModel> {
  @override
  final int typeId = 1;

  @override
  LeaveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LeaveModel(
      userId: fields[0] as String,
      plLeaves: fields[1] as int,
      slLeaves: fields[2] as int,
      clLeaves: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, LeaveModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.plLeaves)
      ..writeByte(2)
      ..write(obj.slLeaves)
      ..writeByte(3)
      ..write(obj.clLeaves);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LeaveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
