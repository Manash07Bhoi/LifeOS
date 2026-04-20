import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/models/routine.dart';

class RoutinesNotifier extends StateNotifier<List<Routine>> {
  final Box<Routine> _box;

  RoutinesNotifier(this._box) : super(_box.values.toList());

  void addRoutine(Routine routine) {
    _box.put(routine.id, routine);
    state = _box.values.toList();
  }

  void updateRoutine(Routine routine) {
    _box.put(routine.id, routine);
    state = _box.values.toList();
  }

  void deleteRoutine(String id) {
    _box.delete(id);
    state = _box.values.toList();
  }
}

final routinesProvider = StateNotifierProvider<RoutinesNotifier, List<Routine>>((ref) {
  final box = Hive.box<Routine>('routinesBox');
  return RoutinesNotifier(box);
});
