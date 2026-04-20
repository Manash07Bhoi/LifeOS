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
