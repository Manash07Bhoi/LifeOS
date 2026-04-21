## 2024-04-20 - Add Tooltips to IconButtons for Accessibility
**Learning:** Flutter `IconButton` widgets without a text label do not inherently provide context to screen readers or keyboard users (on desktop/web). In this app, many core navigational and action buttons were icon-only, lacking screen reader support and hover states.
**Action:** Always add the `tooltip` property to any `IconButton` that does not have an accompanying visible text label to ensure keyboard accessibility and screen reader support, acting as the native Flutter equivalent to web's `aria-label`.

## 2024-04-21 - Expanded Accessibility Support for Custom Interactive Elements
**Learning:** While `IconButton` has a built-in `tooltip` property, custom icon-only buttons built using `GestureDetector` or `AnimatedContainer` (e.g., custom bottom navigation bars or primary action FABs) completely lack context for screen readers and miss native hover states on web/desktop.
**Action:** Always wrap custom interactive widgets (`GestureDetector`, `InkWell`) that lack text labels with the `Tooltip` widget. This natively applies the `aria-label` equivalent, providing immediate accessibility and UX improvements.
