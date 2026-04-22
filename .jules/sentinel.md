## 2024-05-24 - Incomplete Local Data Purge
**Vulnerability:** Using `Hive.box('box').clear()` only empties the records inside a local data box but leaves the physical file and metadata intact, which could be an incomplete local data purge risk if sensitive data patterns persist or if the file isn't explicitly removed.
**Learning:** For a complete and secure data purge in Hive, the actual underlying files must be destroyed. However, `deleteFromDisk()` also closes the box in memory, which crashes the app when navigating back to screens that rely on those boxes.
**Prevention:** Replace `.clear()` with `.deleteFromDisk()`. Immediately afterward, reopen the boxes using `Hive.openBox()` with the correct generic types and encryption ciphers (if any) before invalidating providers and resetting application state.

## 2026-04-22 - Arbitrary URL Launch Protocol Execution Risk
**Vulnerability:** Inline usage of `launchUrl()` directly parses string links without schema validation, allowing potential arbitrary URI scheme execution (e.g., launching unintended local app schemes or system intent triggers if an attacker controls the URL data).
**Learning:** Relying solely on `canLaunchUrl()` is insufficient as it only checks if an app exists to handle the protocol, not if the protocol is safe or intended for the context.
**Prevention:** Create a centralized `safeLaunchUrl()` wrapper that strictly validates allowed schemas (`https`, `http`, `mailto`) and handles platform-specific exceptions via safe UI `SnackBar` feedback.
