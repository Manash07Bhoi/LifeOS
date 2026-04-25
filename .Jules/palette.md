## 2024-04-20 - Add Tooltips to IconButtons for Accessibility
**Learning:** Flutter `IconButton` widgets without a text label do not inherently provide context to screen readers or keyboard users (on desktop/web). In this app, many core navigational and action buttons were icon-only, lacking screen reader support and hover states.
**Action:** Always add the `tooltip` property to any `IconButton` that does not have an accompanying visible text label to ensure keyboard accessibility and screen reader support, acting as the native Flutter equivalent to web's `aria-label`.

## 2024-04-21 - Expanded Accessibility Support for Custom Interactive Elements
**Learning:** While `IconButton` has a built-in `tooltip` property, custom icon-only buttons built using `GestureDetector` or `AnimatedContainer` (e.g., custom bottom navigation bars or primary action FABs) completely lack context for screen readers and miss native hover states on web/desktop.
**Action:** Always wrap custom interactive widgets (`GestureDetector`, `InkWell`) that lack text labels with the `Tooltip` widget. This natively applies the `aria-label` equivalent, providing immediate accessibility and UX improvements.

## 2026-04-22 - Dynamic Tooltips on State-Toggling UI Controls
**Learning:** In state-toggling UI elements like habit completion checkboxes built with `GestureDetector`, a static tooltip isn't enough. The accessibility label needs to reflect the action the user *will* take (e.g., 'Mark as complete' vs 'Mark as incomplete'), not just what the element is.
**Action:** When wrapping a state-dependent interactive widget with a `Tooltip`, dynamically compute the `message` property based on the current state to provide accurate, context-aware feedback to screen readers and mouse hover users.
## 2024-04-23 - Accessibility Support for Quick Actions Panel
**Learning:** `GestureDetector` widgets nested deep within custom components like the `_ActionCard` in `QuickActionsPanel` often lack context for screen readers and do not natively support desktop hover labels, creating an accessibility gap for interactive elements.
**Action:** Always wrap custom interactive UI elements with a `Tooltip`, dynamically passing the available contextual label (e.g., `widget.title`) to provide native `aria-label` equivalent behavior and visible hover states.

## 2024-05-18 - Semantic Labels for Custom Gesture Detectors
**Learning:** Custom interactive widgets (like `GlowButton`) built using raw `GestureDetector` instances are not automatically recognized by screen readers as interactive buttons, causing accessibility tools to only read their inner text without context.
**Action:** Always wrap custom gesture-based UI buttons in a `Semantics` widget with `button: true` and an appropriate `label` (e.g., `Semantics(button: true, label: widget.text, child: ...)`), ensuring they are properly announced to assistive technologies.

## 2024-04-26 - Semantic States for Custom Selectable Buttons
**Learning:** Custom selection buttons (like duration pickers or segmented controls) built with `GestureDetector` do not automatically announce their selected state to screen readers, causing users to be unaware of the active choice.
**Action:** Always wrap custom selectable UI elements in a `Semantics` widget with both `button: true` and the `selected: isActive` property accurately reflecting the current state. Combine with `Tooltip` for mouse users.
