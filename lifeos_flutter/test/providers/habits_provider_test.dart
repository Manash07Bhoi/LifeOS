import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos_flutter/providers/habits_provider.dart';
import 'package:lifeos_flutter/data/models/habit.dart';
import '../fakes/fake_box.dart';

void main() {
  late FakeBox<Habit> fakeBox;
  late HabitsNotifier habitsNotifier;

  setUp(() {
    fakeBox = FakeBox<Habit>();
    habitsNotifier = HabitsNotifier(fakeBox);
  });

  group('HabitsNotifier', () {
    test('initial state is empty when box is empty', () {
      expect(habitsNotifier.state, isEmpty);
    });

    test('addHabit adds habit to box and updates state', () async {
      final habit = Habit(
        title: 'Test Habit',
        description: 'Test Description',
      );

      habitsNotifier.addHabit(habit);

      expect(fakeBox.values, contains(habit));
      expect(habitsNotifier.state, contains(habit));
      expect(habitsNotifier.state.length, 1);
    });

    test('updateHabit updates habit in box and state', () {
      final habit = Habit(
        title: 'Test Habit',
        description: 'Test Description',
      );

      habitsNotifier.addHabit(habit);
      final updatedHabit = habit.copyWith(title: 'Updated Habit');

      habitsNotifier.updateHabit(updatedHabit);

      expect(fakeBox.get(habit.id)?.title, 'Updated Habit');
      expect(
        habitsNotifier.state.firstWhere((h) => h.id == habit.id).title,
        'Updated Habit',
      );
    });

    test('deleteHabit removes habit from box and state', () {
      final habit = Habit(
        title: 'Test Habit',
        description: 'Test Description',
      );

      habitsNotifier.addHabit(habit);
      expect(habitsNotifier.state.length, 1);

      habitsNotifier.deleteHabit(habit.id);

      expect(fakeBox.values, isEmpty);
      expect(habitsNotifier.state, isEmpty);
    });

    group('toggleCompletion', () {
      test('adds completion date when it does not exist', () {
        final habit = Habit(title: 'Test Habit');
        habitsNotifier.addHabit(habit);
        final date = DateTime(2023, 10, 1);

        habitsNotifier.toggleCompletion(habit.id, date);

        final updatedHabit = habitsNotifier.state.first;
        expect(updatedHabit.completionDates, contains(date));
      });

      test('removes completion date when it already exists', () {
        final date = DateTime(2023, 10, 1);
        final habit = Habit(title: 'Test Habit', completionDates: [date]);
        habitsNotifier.addHabit(habit);

        habitsNotifier.toggleCompletion(habit.id, date);

        final updatedHabit = habitsNotifier.state.first;
        expect(updatedHabit.completionDates, isNot(contains(date)));
      });

      test('handles different dates correctly', () {
        final date1 = DateTime(2023, 10, 1);
        final date2 = DateTime(2023, 10, 2);
        final habit = Habit(title: 'Test Habit', completionDates: [date1]);
        habitsNotifier.addHabit(habit);

        habitsNotifier.toggleCompletion(habit.id, date2);

        final updatedHabit = habitsNotifier.state.first;
        expect(updatedHabit.completionDates, contains(date1));
        expect(updatedHabit.completionDates, contains(date2));
      });

      test('does nothing if habit ID is not found', () {
        final date = DateTime(2023, 10, 1);
        habitsNotifier.toggleCompletion('non-existent-id', date);
        expect(habitsNotifier.state, isEmpty);
      });
    });
  });
}
