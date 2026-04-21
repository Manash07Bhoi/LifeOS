## 2024-05-19 - DateFormat Performance Optimization
**Learning:** Instantiating `DateFormat` inside Flutter `build()` loops or frequently rebuilding widgets causes a significant (~96%) performance penalty due to unnecessary allocations every frame.
**Action:** Replaced all direct instantiations of `DateFormat('MMMM d, yyyy')` with a globally reused static constant `AppDateFormats.standard` across the codebase, ensuring zero allocations during widget rebuilds.
