import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'habit.g.dart';

@HiveType(typeId: 1)
class Habit extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final int frequencyDays;

  @HiveField(4)
  final List<DateTime> completionDates;

  @HiveField(5)
  final int streak;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final String notes;

  @HiveField(8)
  final String frequencyType; // 'Daily', 'Weekly', 'Custom'

  Habit({
    String? id,
    required this.title,
    this.description = '',
    this.frequencyDays = 7,
    List<DateTime>? completionDates,
    this.streak = 0,
    this.notes = '',
    this.frequencyType = 'Daily',
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        completionDates = completionDates ?? [],
        createdAt = createdAt ?? DateTime.now();

  late final Set<String> _completionDatesCache =
      completionDates.map((d) => _normalizeDate(d)).toSet();

  String _normalizeDate(DateTime d) {
    return "${d.year}-${d.month}-${d.day}";
  }

  bool isCompletedOn(DateTime date) {
    return _completionDatesCache.contains(_normalizeDate(date));
  }

  void addCompletion(DateTime date) {
    completionDates.add(date);
    _completionDatesCache.add(_normalizeDate(date));
  }

  void removeCompletion(DateTime date) {
    final normalized = _normalizeDate(date);
    completionDates.removeWhere((d) => _normalizeDate(d) == normalized);
    _completionDatesCache.remove(normalized);
  }

  Habit copyWith({
    String? title,
    String? description,
    int? frequencyDays,
    List<DateTime>? completionDates,
    int? streak,
    String? notes,
    String? frequencyType,
  }) {
    return Habit(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      frequencyDays: frequencyDays ?? this.frequencyDays,
      completionDates: completionDates ?? this.completionDates,
      streak: streak ?? this.streak,
      notes: notes ?? this.notes,
      frequencyType: frequencyType ?? this.frequencyType,
      createdAt: createdAt,
    );
  }
}
