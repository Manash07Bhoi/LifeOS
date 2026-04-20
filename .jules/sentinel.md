## 2024-04-20 - [Input Length Limits (DoS prevention)]
**Vulnerability:** Unbounded input fields in `CustomInputField` and terminal `TextField` could allow users (or malicious actors) to inject/paste excessively long strings.
**Learning:** This could lead to UI stutter, memory exhaustion, or Application Not Responding (ANR) states (DoS on the UI level). This is a common attack vector in apps missing explicit constraints on unbounded input fields.
**Prevention:** Always add a strict `maxLength` property to `TextField` and custom input components by default. Hide the counter UI with `counterText: ''` inside `InputDecoration` to maintain design aesthetics without compromising security.
