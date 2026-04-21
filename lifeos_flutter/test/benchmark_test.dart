import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos_flutter/data/models/habit.dart';

void main() {
  test('Benchmark: Habit isCompletedOn (Set) vs List.any', () {
    const int numDates = 10000;
    const int numQueries = 1000;

    // Generate dates (oldest first, newest last, matching typical usage)
    final now = DateTime.now();
    final dates = List.generate(numDates, (i) => now.subtract(Duration(days: numDates - 1 - i)));

    // Target date for query (the oldest date to ensure worst case for List.reversed.any)
    final queryDate = dates.first;

    // Create habit with dates
    final habit = Habit(
      title: 'Benchmark Habit',
      completionDates: List.from(dates),
    );

    // BENCHMARK 1: Old List.any() approach
    final listStopwatch = Stopwatch()..start();
    for (int i = 0; i < numQueries; i++) {
      // Inline the old logic for benchmarking purposes
      habit.completionDates.reversed.any((d) =>
          d.year == queryDate.year && d.month == queryDate.month && d.day == queryDate.day);
    }
    listStopwatch.stop();
    final listTime = listStopwatch.elapsedMicroseconds;

    // BENCHMARK 2: New Set cache approach
    final setStopwatch = Stopwatch()..start();
    for (int i = 0; i < numQueries; i++) {
      habit.isCompletedOn(queryDate);
    }
    setStopwatch.stop();
    final setTime = setStopwatch.elapsedMicroseconds;

    // ignore: avoid_print
    print('--- Benchmark Results ($numDates dates, $numQueries queries) ---');
    // ignore: avoid_print
    print('Old Approach (List.any): $listTimeµs');
    // ignore: avoid_print
    print('New Approach (Set.contains): $setTimeµs');
    // ignore: avoid_print
    print('Speedup: ${(listTime / setTime).toStringAsFixed(2)}x');

    // Verify correctness
    expect(habit.isCompletedOn(queryDate), isTrue);
    expect(habit.isCompletedOn(now.add(const Duration(days: 1))), isFalse);
  });
}
