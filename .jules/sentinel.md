## 2024-04-20 - [Input Length Limits (DoS prevention)]
**Vulnerability:** Unbounded input fields in `CustomInputField` and terminal `TextField` could allow users (or malicious actors) to inject/paste excessively long strings.
**Learning:** This could lead to UI stutter, memory exhaustion, or Application Not Responding (ANR) states (DoS on the UI level). This is a common attack vector in apps missing explicit constraints on unbounded input fields.
**Prevention:** Always add a strict `maxLength` property to `TextField` and custom input components by default. Hide the counter UI with `counterText: ''` inside `InputDecoration` to maintain design aesthetics without compromising security.

## 2025-05-14 - [Missing Network Security Configuration]
**Vulnerability:** Missing `android:networkSecurityConfig` in `AndroidManifest.xml` meant the application wasn't explicitly using the defined network security policy, potentially leaving it vulnerable to misconfiguration or future changes in default Android behavior.
**Learning:** A `networkSecurityConfig` allows for fine-grained control over an app's network security, including disabling cleartext traffic and managing trusted certificate authorities. Simply setting `usesCleartextTraffic="false"` is less comprehensive than a dedicated configuration file.
**Prevention:** Always reference a `network_security_config.xml` in `AndroidManifest.xml` to enforce a strict network security policy, ensuring `cleartextTrafficPermitted` is set to `false` by default.

## 2025-05-15 - [Secure Data Deletion using deleteFromDisk]
**Vulnerability:** Using `.clear()` on Hive boxes to purge system data leaves the file on disk and only empties its contents. While this resets the state, it is not a complete, secure erasure of the underlying file structure.
**Learning:** When implementing a system data purge, use `.deleteFromDisk()` on Hive boxes for secure removal rather than `.clear()`. Because `.deleteFromDisk()` closes the boxes, you MUST immediately re-open them (`Hive.openBox`) using identical generic types and encryption ciphers (if enabled) before invalidating Riverpod providers and navigating. Wrap in a try-catch to prevent crashes.
**Prevention:** Use `.deleteFromDisk()` when sensitive local data needs to be purged, and ensure proper file reopening logic to maintain app stability.
