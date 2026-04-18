import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/models/goal.dart';

class GoalsNotifier extends StateNotifier<List<Goal>> {
  final Box<Goal> _box;

  GoalsNotifier(this._box) : super(_box.values.toList());

  void addGoal(Goal goal) {
    _box.put(goal.id, goal);
    state = _box.values.toList();
  }

  void updateGoal(Goal goal) {
    _box.put(goal.id, goal);
    state = _box.values.toList();
  }

  void deleteGoal(String id) {
    _box.delete(id);
    state = _box.values.toList();
  }
}

final goalsProvider = StateNotifierProvider<GoalsNotifier, List<Goal>>((ref) {
  final box = Hive.box<Goal>('goalsBox');
  return GoalsNotifier(box);
});
