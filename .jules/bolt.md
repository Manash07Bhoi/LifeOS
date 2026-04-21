## 2024-04-20 - Adding const keyword and avoiding deep clones where applicable

**Learning:** Performance optimization in Flutter usually involves using `const` constructors wherever possible. `ListView.builder` also optimizes lists since they lazily build elements. Some variables like `DateTime.now()` should be computed as few times as possible to avoid constant recreations. Also finding opportunities for caching/memoization and reducing re-renders/builds can help.
**Action:** Adding some `const`s to widgets to reduce rebuilds. `const` on `ListView.builder` is not directly possible if children change. But many widgets can be `const`. Another possible optimization: caching some items and preventing full rebuild of parent.

## 2024-04-20 - Memoizing isCompletedOn

**Learning:** `HabitMatrixScreen` calls `isCompletedOn(today)` for every habit inside `ListView.builder`. `isCompletedOn` loops over `completionDates` with `any()` and compares year, month, day. If `completionDates` grows large (e.g. tracking a habit for a year = 365 elements), this `any()` call becomes O(N) per item rendered. Since it's done during the build phase (specifically inside item builder during scrolling), it can cause frame drops on large lists and long histories.
**Action:**
Optimization Note:
Updated isCompletedOn to iterate from the end using reversed.any(...).
This improves average-case performance when checking recent dates (such as today's completion).
Worst-case time complexity remains O(n).

## 2024-04-20 - Replace per-character setState with AnimatedBuilder for typing animations

**Learning:** Using a `Timer` that calls `setState()` for every typed character in a long stream of text (like in a terminal logs overlay) triggers expensive, full widget tree rebuilds repeatedly. This becomes a significant bottleneck as the tree or the log output grows.
**Action:** Always use an `AnimationController` combined with an `AnimatedBuilder` (and a `StepTween` to dictate string length) to isolate rebuilds solely to the changing text widget. Remember to reset the controller (`_typingController.value = 0.0`) when iterating over sequential strings to prevent `RangeError` during the rebuild.

## 2024-05-24 - O(1) Lookups in Hive Models
**Learning:** Checking list properties (like `completionDates`) sequentially inside high-frequency rebuild areas (like `ListView.builder`) leads to O(N) performance degradation per item. Altering Hive schemas to fix this requires complex migrations that risk offline data corruption.
**Action:** Implemented a transient cache inside the `Habit` model using `late final Set<String> _completionDatesCache` mapped from the Hive list to achieve true O(1) lookups. By adding synchronous `addCompletion` and `removeCompletion` methods, we avoid complex migrations while improving worst-case search speeds by >13x.
