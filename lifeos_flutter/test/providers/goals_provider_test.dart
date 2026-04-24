import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos_flutter/providers/goals_provider.dart';
import 'package:lifeos_flutter/data/models/goal.dart';
import '../fakes/fake_box.dart';

void main() {
  late FakeBox<Goal> fakeBox;
  late GoalsNotifier goalsNotifier;

  setUp(() {
    fakeBox = FakeBox<Goal>();
    goalsNotifier = GoalsNotifier(fakeBox);
  });

  group('GoalsNotifier', () {
    test('initial state is empty when box is empty', () {
      expect(goalsNotifier.state, isEmpty);
    });

    test('addGoal adds goal to box and updates state', () async {
      final goal = Goal(
        title: 'Test Goal',
        description: 'Test Description',
        targetDate: DateTime.now(),
        category: 'Work',
      );

      goalsNotifier.addGoal(goal);

      expect(fakeBox.values, contains(goal));
      expect(goalsNotifier.state, contains(goal));
      expect(goalsNotifier.state.length, 1);
    });

    test('updateGoal updates goal in box and state', () {
      final goal = Goal(
        title: 'Test Goal',
        description: 'Test Description',
        targetDate: DateTime.now(),
        category: 'Work',
      );

      goalsNotifier.addGoal(goal);
      final updatedGoal = goal.copyWith(title: 'Updated Goal');

      goalsNotifier.updateGoal(updatedGoal);

      expect(fakeBox.get(goal.id)?.title, 'Updated Goal');
      expect(
        goalsNotifier.state.firstWhere((g) => g.id == goal.id).title,
        'Updated Goal',
      );
    });

    test('deleteGoal removes goal from box and state', () {
      final goal = Goal(
        title: 'Test Goal',
        description: 'Test Description',
        targetDate: DateTime.now(),
        category: 'Work',
      );

      goalsNotifier.addGoal(goal);
      expect(goalsNotifier.state.length, 1);

      goalsNotifier.deleteGoal(goal.id);

      expect(fakeBox.values, isEmpty);
      expect(goalsNotifier.state, isEmpty);
    });
  });
}
