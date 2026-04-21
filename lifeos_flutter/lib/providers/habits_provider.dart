import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/models/habit.dart';

class HabitsNotifier extends StateNotifier<List<Habit>> {
  final Box<Habit> _box;

  HabitsNotifier(this._box) : super(_box.values.toList());

  void addHabit(Habit habit) {
    _box.put(habit.id, habit);
    state = _box.values.toList();
  }

  void updateHabit(Habit habit) {
    _box.put(habit.id, habit);
    state = _box.values.toList();
  }

  void deleteHabit(String id) {
    _box.delete(id);
    state = _box.values.toList();
  }

  void toggleCompletion(String id, DateTime date) {
    final habit = _box.get(id);
    if (habit != null) {
      final updatedHabit = habit.copyWith(
        completionDates: List<DateTime>.from(habit.completionDates),
      );

      if (updatedHabit.isCompletedOn(date)) {
        updatedHabit.removeCompletion(date);
      } else {
        updatedHabit.addCompletion(date);
      }

      updateHabit(updatedHabit);
    }
  }
}

final habitsProvider = StateNotifierProvider<HabitsNotifier, List<Habit>>((ref) {
  final box = Hive.box<Habit>('habitsBox');
  return HabitsNotifier(box);
});
