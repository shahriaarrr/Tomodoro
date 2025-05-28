// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasky.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskyAdapter extends TypeAdapter<Tasky> {
  @override
  final int typeId = 0;

  @override
  Tasky read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tasky(
      taskyId: fields[0] as int,
      content: fields[1] as String,
      priority: fields[2] as TaskyPriority,
      isDone: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Tasky obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.taskyId)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.priority)
      ..writeByte(3)
      ..write(obj.isDone);
  }
}

class TaskyPriorityAdapter extends TypeAdapter<TaskyPriority> {
  @override
  final int typeId = 1;

  @override
  TaskyPriority read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaskyPriority.low;
      case 1:
        return TaskyPriority.medium;
      case 2:
        return TaskyPriority.high;
      default:
        return TaskyPriority.low;
    }
  }

  @override
  void write(BinaryWriter writer, TaskyPriority obj) {
    switch (obj) {
      case TaskyPriority.low:
        writer.writeByte(0);
        break;
      case TaskyPriority.medium:
        writer.writeByte(1);
        break;
      case TaskyPriority.high:
        writer.writeByte(2);
        break;
    }
  }
}
