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
## 2024-04-20 - Extract ListView items to const widgets

**Learning:** When using `ListView.builder`, placing complex, deeply nested widget trees directly inside the `itemBuilder` function prevents the Flutter framework from using `const` optimizations, leading to unnecessary rebuilds when scrolling, especially if `Theme.of(context)` or other InheritedWidgets trigger an update.
**Action:** Always extract the repeated item UI into a separate private class (e.g., `_CommandListItem`) that extends `StatelessWidget`. By using a `const` constructor for this extracted widget, Flutter can safely skip rebuilding list items that scroll out of view and back in, significantly improving scrolling performance and reducing Jank.
## 2024-04-20 - Extract high-frequency Riverpod updates into separate ConsumerWidgets

**Learning:** In a screen with a timer, calling `ref.watch(provider)` at the top level causes the entire screen to rebuild every time the timer ticks (every second). This can lead to performance issues and unnecessary repaints.
**Action:** Extract the frequently updating UI component (like the timer display) into a separate `ConsumerWidget`. Use `ref.watch(provider.select(...))` to specifically target the changing state, isolating the rebuilds only to the component that actually needs to change.
