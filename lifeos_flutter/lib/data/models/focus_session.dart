import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'focus_session.g.dart';

@HiveType(typeId: 2)
class FocusSession extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int durationMinutes;

  @HiveField(2)
  final DateTime startTime;

  @HiveField(3)
  final DateTime endTime;

  @HiveField(4)
  final String? relatedGoalId;

  @HiveField(5)
  final String? notes;

  FocusSession({
    String? id,
    required this.durationMinutes,
    required this.startTime,
    required this.endTime,
    this.relatedGoalId,
    this.notes,
  }) : id = id ?? const Uuid().v4();
}
