import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'routine.g.dart';

@HiveType(typeId: 2)
class Routine extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<String> linkedHabits;

  @HiveField(3)
  final int focusDuration;

  @HiveField(4)
  final String notes;

  Routine({
    String? id,
    required this.name,
    this.linkedHabits = const [],
    this.focusDuration = 25,
    this.notes = '',
  }) : id = id ?? const Uuid().v4();

  Routine copyWith({
    String? name,
    List<String>? linkedHabits,
    int? focusDuration,
    String? notes,
  }) {
    return Routine(
      id: id,
      name: name ?? this.name,
      linkedHabits: linkedHabits ?? this.linkedHabits,
      focusDuration: focusDuration ?? this.focusDuration,
      notes: notes ?? this.notes,
    );
  }
}
