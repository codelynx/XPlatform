# XPlatform

A Swift package that provides cross-platform type aliases and utilities for building applications that work seamlessly across iOS, macOS, tvOS, and watchOS.

## Overview

XPlatform simplifies cross-platform Swift development by providing unified type aliases and convenience methods that abstract away platform-specific differences between AppKit (macOS) and UIKit (iOS/tvOS/watchOS).

📚 **New to XPlatform?** Check out our [Getting Started Guide](GETTING_STARTED.md) to understand the problems XPlatform solves and see real-world examples.

## Installation

### Swift Package Manager

Add XPlatform to your project by adding the following to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/XPlatform.git", from: "1.0.0")
]
```

Or add it through Xcode:
1. File → Add Package Dependencies
2. Enter the repository URL
3. Select the version requirements

## Requirements

- iOS 15.0+
- macOS 12.0+
- tvOS 15.0+
- watchOS 8.0+
- Swift 5.7+

## API Reference

### Type Aliases

XPlatform provides unified type aliases that map to the appropriate platform-specific types:

| XPlatform Type | macOS (AppKit) | iOS/tvOS/watchOS (UIKit) |
|----------------|----------------|---------------------------|
| `XView` | `NSView` | `UIView` |
| `XViewController` | `NSViewController` | `UIViewController` |
| `XWindow` | `NSWindow` | `UIWindow` |
| `XImage` | `NSImage` | `UIImage` |
| `XColor` | `NSColor` | `UIColor` |
| `XFont` | `NSFont` | `UIFont` |
| `XBezierPath` | `NSBezierPath` | `UIBezierPath` |
| `XGestureRecognizer` | `NSGestureRecognizer` | `UIGestureRecognizer` |
| `XTapGestureRecognizer` | `NSClickGestureRecognizer` | `UITapGestureRecognizer` |
| `XPanGestureRecognizer` | `NSPanGestureRecognizer` | `UIPanGestureRecognizer` |
| `XCollectionView` | `NSCollectionView` | `UICollectionView` |
| `XCollectionViewDelegate` | `NSCollectionViewDelegate` | `UICollectionViewDelegate` |
| `XCollectionViewDataSource` | `NSCollectionViewDataSource` | `UICollectionViewDataSource` |
| `XViewControllerRepresentable` | `NSViewControllerRepresentable` | `UIViewControllerRepresentable` |
| `XViewRepresentable` | `NSViewRepresentable` | `UIViewRepresentable` |
| `XMenu` | `NSMenu` | `UIMenu` |
| `XCollectionViewDiffableDataSource` | `NSCollectionViewDiffableDataSource` | `UICollectionViewDiffableDataSource` |
| `XCollectionViewLayout` | `NSCollectionViewLayout` | `UICollectionViewLayout` |
| `XAlert` | `NSAlert` | `UIAlertController` |
| `XPasteboard` | `NSPasteboard` | `UIPasteboard` |

### Extensions

#### XView Extensions

```swift
extension XView {
    func setNeedsLayout()
    var usesFlippedCoordinates: Bool { get }
    func makeFirstResponder()
    func resignFirstResponder()
    func addTapGesture(target: Any?, action: Selector)
    func addPanGesture(target: Any?, action: Selector)
    func addContextMenu(_ menu: XMenu) // macOS
    func addContextMenu(provider: @escaping () -> XMenu?) // iOS 13.0+
}
```

##### Layout
- **`setNeedsLayout()`**: Marks the view as needing layout
  - Platform Notes: On macOS, this sets `needsLayout = true`. On iOS/tvOS/watchOS, the native method is already available

##### Coordinate System
- **`usesFlippedCoordinates`**: Returns whether the view uses a flipped coordinate system
  - Returns: `true` if the coordinate system origin is at top-left, `false` if at bottom-left
  - Platform Notes: iOS always returns `true`, macOS returns the value of `isFlipped`

##### Responder Chain
- **`makeFirstResponder()`**: Makes this view the first responder
  - Platform Notes: On macOS uses `window?.makeFirstResponder(self)`, on iOS uses `becomeFirstResponder()`
- **`resignFirstResponder()`**: Resigns first responder status
  - Platform Notes: Handles platform differences in resigning first responder

##### Gesture Recognizers
- **`addTapGesture(target:action:)`**: Adds a tap/click gesture recognizer
  - Platform Notes: Uses `NSClickGestureRecognizer` on macOS, `UITapGestureRecognizer` on iOS
- **`addTapGesture(target:action:taps:)`**: Adds a tap/click gesture recognizer with specific tap count
  - Parameters: `taps` - Number of taps required (e.g., 2 for double-tap)
  - Platform Notes: Sets `numberOfClicksRequired` on macOS, `numberOfTapsRequired` on iOS
- **`addPanGesture(target:action:)`**: Adds a pan gesture recognizer

##### Context Menus
- **`addContextMenu(_:)`** (macOS): Adds a context menu to the view
- **`addContextMenu(provider:)`** (iOS 13.0+): Adds a context menu with a provider closure

#### XImage Extensions

```swift
extension XImage {
    func jpegData(compressionQuality: CGFloat) -> Data?
}
```
- **Description**: Converts the image to JPEG data with the specified compression quality
- **Parameters**: 
  - `compressionQuality`: A value between 0.0 (maximum compression) and 1.0 (no compression)
- **Returns**: JPEG data representation of the image, or `nil` if conversion fails
- **Platform Notes**: Only available on macOS; iOS/tvOS/watchOS already provide this method natively

### SwiftUI Integration

#### Image Initializer

```swift
extension Image {
    init(_ image: XImage)
}
```
- **Description**: Creates a SwiftUI `Image` from a platform-specific image
- **Platform Notes**: Uses `init(nsImage:)` on macOS and `init(uiImage:)` on other platforms

#### View Modifiers

##### Link Button Style
```swift
extension View {
    func linkButtonStyle() -> some View
}
```
- **Description**: Applies a link-style button appearance
- **Platform Behavior**:
  - macOS: Uses `.buttonStyle(.link)`
  - iOS/tvOS/watchOS: Uses `.buttonStyle(.plain)` with blue foreground color

##### Primary Button Style
```swift
extension View {
    func primaryButtonStyle() -> some View
}
```
- **Description**: Applies a prominent button style suitable for primary actions
- **Platform Behavior**: Uses `.borderedProminent` on all platforms

##### Secondary Button Style
```swift
extension View {
    func secondaryButtonStyle() -> some View
}
```
- **Description**: Applies a bordered button style suitable for secondary actions
- **Platform Behavior**: Uses `.bordered` on all platforms

#### XFont Extensions

```swift
extension XFont {
    static func xSystemFont(ofSize size: CGFloat, weight: XFont.Weight) -> XFont
    static var xSystemFontSize: CGFloat { get }
    static var xSmallSystemFontSize: CGFloat { get }
    static var xLabelFontSize: CGFloat { get }
}
```
- **`xSystemFont(ofSize:weight:)`**: Creates a system font with the specified size and weight
- **`xSystemFontSize`**: Returns the default system font size
- **`xSmallSystemFontSize`**: Returns the default small system font size
- **`xLabelFontSize`**: Returns the default label font size
- **Note**: Methods are prefixed with 'x' to avoid conflicts with native properties

#### XPasteboard Extensions

```swift
extension XPasteboard {
    static var xGeneral: XPasteboard { get }
    var xString: String? { get set }
}
```
- **`xGeneral`**: Returns the general/system pasteboard
- **`xString`**: Gets or sets the string content of the pasteboard
- **Note**: Properties are prefixed with 'x' to avoid conflicts with native properties

#### XAlert Extensions

```swift
struct XAlertStyle {
    static let informational = 0
    static let warning = 1
    static let critical = 2
}

extension XAlert {
    static func showAlert(title: String, message: String, style: Int = XAlertStyle.informational)
}
```
- **`showAlert(title:message:style:)`**: Shows a simple alert with a message
  - Platform Notes: On macOS, displays a modal alert. On iOS, prints to console (would need view controller for proper presentation)

### XPlatform Struct

```swift
struct XPlatform {
    // Colors
    static let primaryBackgroundColor: XColor
    static let secondaryBackgroundColor: XColor
    static let tertiaryBackgroundColor: XColor
    static var adaptiveTextBackgroundColor: XColor { get }
    static var labelColor: XColor { get }
    static var secondaryLabelColor: XColor { get }
    static var separatorColor: XColor { get }
    
    // File System
    static var documentsDirectory: URL { get }
    static var applicationSupportDirectory: URL { get }
    static var cachesDirectory: URL { get }
    static var temporaryDirectory: URL { get }
}
```

#### Color Properties

| Property | macOS | iOS/tvOS/watchOS |
|----------|-------|------------------|
| `primaryBackgroundColor` | `NSColor.controlBackgroundColor` | `UIColor.systemBackground` |
| `secondaryBackgroundColor` | `NSColor.windowBackgroundColor` | `UIColor.secondarySystemBackground` |
| `tertiaryBackgroundColor` | `NSColor.controlBackgroundColor` | `UIColor.tertiarySystemBackground` |
| `adaptiveTextBackgroundColor` | `NSColor.textBackgroundColor` | `UIColor.systemBackground` |
| `labelColor` | `NSColor.labelColor` | `UIColor.label` |
| `secondaryLabelColor` | `NSColor.secondaryLabelColor` | `UIColor.secondaryLabel` |
| `separatorColor` | `NSColor.separatorColor` | `UIColor.separator` |

#### File System Properties

- **`documentsDirectory`**: Returns the user's documents directory URL
- **`applicationSupportDirectory`**: Returns the application support directory URL
- **`cachesDirectory`**: Returns the caches directory URL
- **`temporaryDirectory`**: Returns the temporary directory URL

## Usage Examples

### Basic Type Usage

```swift
import XPlatform

// Works on all platforms
let view = XView()
let color = XColor.red
let image = XImage()

// SwiftUI integration
struct ContentView: View {
    var body: some View {
        Image(myXImage)
            .resizable()
        
        Button("Primary Action") {
            // Action
        }
        .primaryButtonStyle()
    }
}
```

### Cross-Platform View Controller

```swift
import XPlatform

class MyViewController: XViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = XPlatform.primaryBackgroundColor
        
        // Your cross-platform code here
    }
}
```

### Working with Images

```swift
import XPlatform

func processImage(_ image: XImage) -> Data? {
    // This works on all platforms
    #if os(macOS)
    return image.jpegData(compressionQuality: 0.8)
    #else
    return image.jpegData(compressionQuality: 0.8)
    #endif
}
```

### Gesture Handling

```swift
import XPlatform

class InteractiveView: XView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Add single tap gesture
        self.addTapGesture(target: self, action: #selector(handleTap))
        
        // Add double tap gesture
        self.addTapGesture(target: self, action: #selector(handleDoubleTap), taps: 2)
        
        // Add triple tap gesture
        self.addTapGesture(target: self, action: #selector(handleTripleTap), taps: 3)
        
        // Add pan gesture
        self.addPanGesture(target: self, action: #selector(handlePan))
    }
    
    @objc func handleTap(_ gesture: XTapGestureRecognizer) {
        print("Single tap!")
    }
    
    @objc func handleDoubleTap(_ gesture: XTapGestureRecognizer) {
        print("Double tap!")
    }
    
    @objc func handleTripleTap(_ gesture: XTapGestureRecognizer) {
        print("Triple tap!")
    }
    
    @objc func handlePan(_ gesture: XPanGestureRecognizer) {
        print("View panned!")
    }
}
```

### Font Usage

```swift
import XPlatform

// Create system fonts
let titleFont = XFont.xSystemFont(ofSize: 24, weight: .bold)
let bodyFont = XFont.xSystemFont(ofSize: XFont.xSystemFontSize, weight: .regular)
let smallFont = XFont.xSystemFont(ofSize: XFont.xSmallSystemFontSize, weight: .light)
```

### Pasteboard Operations

```swift
import XPlatform

// Copy text to pasteboard
let pasteboard = XPasteboard.xGeneral
pasteboard.xString = "Hello, Cross-Platform!"

// Read text from pasteboard
if let copiedText = pasteboard.xString {
    print("Pasteboard contains: \(copiedText)")
}
```

### File System Access

```swift
import XPlatform

// Access common directories
let documentsURL = XPlatform.documentsDirectory
let cachesURL = XPlatform.cachesDirectory
let tempURL = XPlatform.temporaryDirectory

// Save a file to documents
let fileURL = documentsURL.appendingPathComponent("data.txt")
try "Hello, World!".write(to: fileURL, atomically: true, encoding: .utf8)
```

### Adaptive Colors

```swift
import XPlatform
import SwiftUI

struct ThemedView: View {
    var body: some View {
        VStack {
            Text("Primary Label")
                .foregroundColor(Color(XPlatform.labelColor))
            
            Text("Secondary Label")
                .foregroundColor(Color(XPlatform.secondaryLabelColor))
            
            Divider()
                .background(Color(XPlatform.separatorColor))
        }
        .background(Color(XPlatform.adaptiveTextBackgroundColor))
    }
}
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This package is available under the MIT license. See the LICENSE file for more info.