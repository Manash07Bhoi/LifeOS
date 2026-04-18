// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'command_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CommandHistoryAdapter extends TypeAdapter<CommandHistory> {
  @override
  final int typeId = 3;

  @override
  CommandHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CommandHistory(
      id: fields[0] as String?,
      commandText: fields[1] as String,
      executedAt: fields[2] as DateTime,
      wasSuccessful: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CommandHistory obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.commandText)
      ..writeByte(2)
      ..write(obj.executedAt)
      ..writeByte(3)
      ..write(obj.wasSuccessful);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommandHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
