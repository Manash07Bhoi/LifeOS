import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'command_history.g.dart';

@HiveType(typeId: 3)
class CommandHistory extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String commandText;

  @HiveField(2)
  final DateTime executedAt;

  @HiveField(3)
  final bool wasSuccessful;

  CommandHistory({
    String? id,
    required this.commandText,
    required this.executedAt,
    this.wasSuccessful = true,
  }) : id = id ?? const Uuid().v4();
}
