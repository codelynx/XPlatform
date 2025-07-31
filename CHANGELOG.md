# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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