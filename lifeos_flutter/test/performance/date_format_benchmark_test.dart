import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:lifeos_flutter/core/utils/date_formats.dart'; // Adjust import if needed

void main() {
  test('DateFormat performance benchmark', () {
    final date = DateTime.now();
    const iterations = 10000;

    // Baseline: instantiating DateFormat in a loop
    final baselineStart = DateTime.now();
    for (int i = 0; i < iterations; i++) {
      final formatter = DateFormat('MMMM d, yyyy');
      formatter.format(date);
    }
    final baselineEnd = DateTime.now();
    final baselineDuration = baselineEnd.difference(baselineStart).inMicroseconds;

    // Optimized: using pre-instantiated formatter
    final optimizedStart = DateTime.now();
    for (int i = 0; i < iterations; i++) {
      AppDateFormats.standard.format(date);
    }
    final optimizedEnd = DateTime.now();
    final optimizedDuration = optimizedEnd.difference(optimizedStart).inMicroseconds;

    debugPrint('Baseline (instantiation inside loop) duration: $baselineDuration µs');
    debugPrint('Optimized (reusing instance) duration: $optimizedDuration µs');
    debugPrint('Improvement: ${(baselineDuration - optimizedDuration) / baselineDuration * 100}%');

    expect(optimizedDuration, lessThan(baselineDuration));
  });
}
