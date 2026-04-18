import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'goal.g.dart';

@HiveType(typeId: 0)
class Goal extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final DateTime targetDate;

  @HiveField(4)
  final double progress;

  @HiveField(5)
  final String category;

  @HiveField(6)
  final DateTime createdAt;

  Goal({
    String? id,
    required this.title,
    required this.description,
    required this.targetDate,
    this.progress = 0.0,
    required this.category,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  Goal copyWith({
    String? title,
    String? description,
    DateTime? targetDate,
    double? progress,
    String? category,
  }) {
    return Goal(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      targetDate: targetDate ?? this.targetDate,
      progress: progress ?? this.progress,
      category: category ?? this.category,
      createdAt: createdAt,
    );
  }
}
