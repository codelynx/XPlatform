# XPlatform

A Swift package that provides cross-platform type aliases and utilities for building applications that work seamlessly across iOS, macOS, tvOS, and watchOS.

## Overview

XPlatform simplifies cross-platform Swift development by providing unified type aliases and convenience methods that abstract away platform-specific differences between AppKit (macOS) and UIKit (iOS/tvOS/watchOS).

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
| `XCollectionView` | `NSCollectionView` | `UICollectionView` |
| `XCollectionViewDelegate` | `NSCollectionViewDelegate` | `UICollectionViewDelegate` |
| `XCollectionViewDataSource` | `NSCollectionViewDataSource` | `UICollectionViewDataSource` |
| `XViewControllerRepresentable` | `NSViewControllerRepresentable` | `UIViewControllerRepresentable` |
| `XViewRepresentable` | `NSViewRepresentable` | `UIViewRepresentable` |
| `XMenu` | `NSMenu` | `UIMenu` |
| `XCollectionViewDiffableDataSource` | `NSCollectionViewDiffableDataSource` | `UICollectionViewDiffableDataSource` |
| `XCollectionViewLayout` | `NSCollectionViewLayout` | `UICollectionViewLayout` |

### Extensions

#### XView Extensions

```swift
extension XView {
    func setNeedsLayout()
}
```
- **Description**: Marks the view as needing layout
- **Platform Notes**: On macOS, this sets `needsLayout = true`. On iOS/tvOS/watchOS, the native `setNeedsLayout()` is already available

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

### XPlatform Struct

```swift
struct XPlatform {
    static let primaryBackgroundColor: XColor
    static let secondaryBackgroundColor: XColor
    static let tertiaryBackgroundColor: XColor
}
```

Provides cross-platform color constants:

| Property | macOS | iOS/tvOS/watchOS |
|----------|-------|------------------|
| `primaryBackgroundColor` | `NSColor.controlBackgroundColor` | `UIColor.systemBackground` |
| `secondaryBackgroundColor` | `NSColor.windowBackgroundColor` | `UIColor.systemBackground` |
| `tertiaryBackgroundColor` | `NSColor.controlBackgroundColor` | `UIColor.secondarySystemBackground` |

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

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This package is available under the MIT license. See the LICENSE file for more info.