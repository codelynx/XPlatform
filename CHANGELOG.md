# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.2.0] - 2026-04-22

### Added
- **Safe directory accessors.** `XPlatform.documentsDirectoryIfAvailable`,
  `applicationSupportDirectoryIfAvailable`, and `cachesDirectoryIfAvailable`
  return `URL?` and do not force-unwrap the underlying `FileManager` lookup.
  The existing force-unwrapped properties (`documentsDirectory`, etc.) are
  now implemented in terms of these optional variants — callers get the same
  behavior, and new code can prefer the `IfAvailable` form.
  `temporaryDirectory` did not have a force-unwrap and is unchanged.
- **`CGRect.transformIfValid(to:)`** — returns `CGAffineTransform?`,
  yielding `nil` when the source rectangle has zero width or zero height
  (which would produce an invalid transform via the unchecked
  `transform(to:)`). Negative dimensions are permitted — the math is valid
  as long as the divisor is nonzero.

### Notes

This is an additive, non-breaking release. The existing
force-unwrapping directory properties and the existing `transform(to:)`
remain public; the new APIs are safer siblings that you can opt into where
the input may be untrusted or degenerate.

## [2.1.0] - 2026-04-21

### Added
- **`XCanvasView`** — base class for canvas / document / content views whose
  coordinate system is top-left origin on both platforms. On macOS this is an
  `NSView` subclass that overrides `isFlipped` to return `true`; on iOS it is
  a typealias for `UIView` (already top-left).
- **`XCanvasClipView`** (macOS only) — `NSClipView` subclass with
  `isFlipped = true`. Install on an `NSScrollView` via
  `scrollView.contentView = XCanvasClipView(...)` to extend the top-left
  convention through the clip layer.
- README section "Canvas Coordinate Convention" documenting the pattern:
  subclass `XCanvasView`, set `bounds == scene.bounds`, and native event APIs
  return scene coordinates directly with no manual conversion math.

### Design notes

The intent is to solve the coordinate / origin problem at the geometry layer
rather than by bridging events. `UITouch` and `NSEvent` carry genuinely
different data (force, azimuth, modifiers, estimated-property updates), so
XPlatform does not attempt to unify them. Once the content view's coordinate
system is top-left and its bounds match the logical scene, native
`touch.location(in:)` / `view.convert(event.locationInWindow, from: nil)`
return scene coordinates directly — and platform-specific event code stays
small and honest.

## [2.0.0] - 2026-04-21

### Changed (breaking)
- **Supported platforms narrowed to iOS 15+ and macOS 12+.** Previous versions
  also declared tvOS 15 and watchOS 8, but those platforms did not actually
  compile — several UIKit semantic color APIs XPlatform relies on are
  unavailable there. This release aligns declared support with what was
  actually tested. If you need tvOS or watchOS, please open an issue.
- **Unified naming convention.** Member-level extensions now use the plain
  native name wherever possible, since the `XColor`/`XFont`/... return type
  already signals cross-platform intent. The lowercase `x` prefix is reserved
  for the rare case where a plain name would shadow a native property.

### Added
- `XColor.primaryBackground` / `secondaryBackground` / `tertiaryBackground` —
  canonical cross-platform background tiers.
- Matching `Color.primaryBackground` / `secondaryBackground` / `tertiaryBackground`
  for SwiftUI.
- `XView.tintColor` on macOS (read-only, returns `controlAccentColor`), giving
  cross-platform access without `#if`.
- `XPasteboard.stringValue` — unified replacement for `xString`.

### Removed
- `XPlatform.primaryBackgroundColor`, `secondaryBackgroundColor`,
  `tertiaryBackgroundColor` — superseded by `XColor.primaryBackground` etc.
- `XView.xTintColor` and `XView.effectiveTintColor` — use `tintColor` directly.
- `XFont.xSystemFont(ofSize:weight:)`, `xSystemFontSize`, `xSmallSystemFontSize`,
  `xLabelFontSize` — all exist natively on both `NSFont` and `UIFont`, so the
  wrappers were pure pass-throughs.
- `XPasteboard.xGeneral` — `.general` works cross-platform natively.
- `XPasteboard.xString` — renamed to `stringValue`.
- `XColor.xLabel`, `xSecondaryLabel`, `xTertiaryLabel`, `xSeparator`, `xLink`,
  `xPlaceholderText`, `xControlBackground`, `xGrid`, `xSelectedContentBackground`,
  `xDisabledText`, and `windowBackground` — redundant with their plain-named
  equivalents (native on iOS; provided on macOS via the existing extension).

### Fixed
- iOS compile bug in `XView.resignFirstResponder()` that used `super` inside an
  extension. The method is now macOS-only; on iOS use the native
  `UIResponder.resignFirstResponder()`.
- Dropped redundant `@available` checks against iOS 13/14 and macOS 10.14/11.0
  that were always true under the declared deployment targets.

### Migration

| Before | After |
|--------|-------|
| `XPlatform.primaryBackgroundColor` | `XColor.primaryBackground` |
| `XPlatform.secondaryBackgroundColor` | `XColor.secondaryBackground` |
| `XPlatform.tertiaryBackgroundColor` | `XColor.tertiaryBackground` |
| `XFont.xSystemFont(ofSize:weight:)` | `XFont.systemFont(ofSize:weight:)` |
| `XFont.xSystemFontSize` | `XFont.systemFontSize` |
| `XPasteboard.xGeneral` | `XPasteboard.general` |
| `pasteboard.xString` | `pasteboard.stringValue` |
| `XColor.xLabel` | `XColor.label` |
| `view.xTintColor` / `view.effectiveTintColor` | `view.tintColor` |

## [1.1.5] - 2025-08-03

### Added
- **Tint Color Support for XView**
  - `xTintColor` property - Cross-platform tint color getter/setter
  - `effectiveTintColor` property - Gets the effective tint color (respects system accent color on macOS)

- **Purpose-Specific Color Properties on XView**
  - `appropriateBackgroundColor` - Context-aware background color based on view type and hierarchy
  - `appropriateLabelColor` - Context-aware text color for controls vs regular views
  - `appropriateBorderColor` - Border/stroke color for the view
  - `appropriateSelectionColor` - Selection/highlight color

- **Enhanced XColor Semantic Mappings**
  - **Selection Colors**
    - `selectedContentBackground` - Selected content background color
    - `unemphasizedSelectedContentBackground` - Unemphasized selected content
    - `selectedTextBackground` - Selected text background
    - `selectedControl` - Selected control color (respects accent color)
    - `alternateSelectedControl` - Alternate selection for lists
  - **Control Colors**
    - `controlText` - Text color for controls
    - `disabledControlText` - Disabled control text color
    - `controlBackground` - Control background color
    - `textBackground` - Text field background color
  - **Cross-platform Semantic Colors** (prefixed with 'x')
    - `accent` - User's accent/tint color preference
    - `windowBackground` - Main window/view background
    - `xControlBackground` - Background for controls
    - `xLabel`, `xSecondaryLabel`, `xTertiaryLabel` - Text hierarchy
    - `xSeparator` - Divider lines
    - `xLink` - Link text color
    - `xGrid` - Table/collection grid lines
    - `xPlaceholderText` - Placeholder text in controls
    - `xSelectedContentBackground` - Selected content highlighting
    - `xDisabledText` - Disabled state text

- **Purpose-Specific Color Helper Methods**
  - `colorForInteractiveElement()` - For buttons, links, etc.
  - `colorForSuccess()` - Green color for success states
  - `colorForWarning()` - Orange color for warnings
  - `colorForError()` - Red color for errors
  - `colorForInfo()` - Blue color for information
  - `colorForDisabledState()` - For disabled elements
  - `colorForPlaceholder()` - For placeholder text
  - `colorForSelection()` - For selected content

### Fixed
- Deprecated `alternateSelectedControlColor` usage with proper macOS 11.0+ availability check
- All `controlAccentColor` usage now has proper macOS 10.14+ availability checks

## [1.1.4] - 2025-07-30

### Added
- **Comprehensive XColor Extension** for cross-platform color support
  - iOS-style color properties now available on macOS
  - Enables unified color usage without platform conditionals

- **Background Colors**
  - `systemBackground` - Maps to `windowBackgroundColor`
  - `secondarySystemBackground` - Maps to `controlBackgroundColor`
  - `tertiarySystemBackground` - Maps to `underPageBackgroundColor`
  - `systemGroupedBackground` - Maps to `controlBackgroundColor`
  - `secondarySystemGroupedBackground` - Maps to `windowBackgroundColor`
  - `tertiarySystemGroupedBackground` - Maps to `underPageBackgroundColor`

- **Label Colors**
  - `label` - Maps to `labelColor`
  - `secondaryLabel` - Maps to `secondaryLabelColor`
  - `tertiaryLabel` - Maps to `tertiaryLabelColor`
  - `quaternaryLabel` - Maps to `quaternaryLabelColor`
  - `placeholderText` - Maps to `placeholderTextColor`

- **Fill Colors**
  - `systemFill` - Maps to `unemphasizedSelectedContentBackgroundColor`
  - `secondarySystemFill` - With 0.8 alpha
  - `tertiarySystemFill` - With 0.6 alpha
  - `quaternarySystemFill` - With 0.4 alpha

- **Separator Colors**
  - `separator` - Maps to `separatorColor`
  - `opaqueSeparator` - Maps to `gridColor`

- **Other Colors**
  - `link` - Maps to `linkColor`
  - `systemGray2` through `systemGray6` - Gray scale colors

### Notes
- System colors (systemBlue, systemGreen, etc.) are already available natively on macOS 10.14+
- All color mappings maintain semantic meaning across platforms

## [1.1.0] - 2025-07-24

### Added
- **New Type Aliases**
  - `XFont` - Cross-platform font type
  - `XBezierPath` - Path drawing type
  - `XGestureRecognizer` - Base gesture recognizer
  - `XTapGestureRecognizer` - Tap/click gesture recognizer
  - `XPanGestureRecognizer` - Pan gesture recognizer
  - `XAlert` - Alert/dialog type
  - `XPasteboard` - Clipboard/pasteboard type

- **Enhanced XView Extensions**
  - `usesFlippedCoordinates` - Detect coordinate system orientation
  - `makeFirstResponder()` / `resignFirstResponder()` - Unified responder chain management
  - `addTapGesture(target:action:)` - Add tap gesture recognizer
  - `addTapGesture(target:action:taps:)` - Add tap gesture with tap count (NEW)
  - `addPanGesture(target:action:)` - Add pan gesture recognizer
  - `addContextMenu()` - Platform-specific context menu support

- **XFont Extensions** (prefixed with 'x' to avoid conflicts)
  - `xSystemFont(ofSize:weight:)` - Create system font
  - `xSystemFontSize` - Default system font size
  - `xSmallSystemFontSize` - Small system font size
  - `xLabelFontSize` - Label font size

- **XPasteboard Extensions** (prefixed with 'x' to avoid conflicts)
  - `xGeneral` - Access general pasteboard
  - `xString` - Get/set string content

- **XPlatform Enhancements**
  - Adaptive colors: `adaptiveTextBackgroundColor`, `labelColor`, `secondaryLabelColor`, `separatorColor`
  - File system helpers: `documentsDirectory`, `applicationSupportDirectory`, `cachesDirectory`, `temporaryDirectory`

- **Alert Support**
  - `XAlertStyle` struct with style constants
  - `XAlert.showAlert(title:message:style:)` - Show platform alerts

### Documentation
- Added comprehensive GETTING_STARTED.md guide
- Enhanced README.md with new API documentation
- Added multiple real-world examples

### Fixed
- Made XPlatform struct and its properties public
- Avoided naming conflicts with native properties using 'x' prefix

## [1.0.0] - 2025-07-24

### Initial Release
- Basic type aliases for cross-platform development
- XView, XViewController, XWindow, XImage, XColor
- Collection view related types
- SwiftUI integration helpers
- Basic color constants in XPlatform struct