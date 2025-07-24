# Getting Started with XPlatform

## The Problem: Apple's Platform Fragmentation

When developing for Apple platforms, you face a fundamental challenge: **macOS uses AppKit while iOS/tvOS/watchOS use UIKit**. These frameworks share similar concepts but have different APIs:

```swift
// On macOS
let view = NSView()
let color = NSColor.red
let font = NSFont.systemFont(ofSize: 14)

// On iOS
let view = UIView()
let color = UIColor.red
let font = UIFont.systemFont(ofSize: 14)
```

This leads to:
- **Code duplication** - Writing the same logic twice with different types
- **Conditional compilation hell** - Your code becomes littered with `#if os(macOS)`
- **Maintenance burden** - Changes need to be made in multiple places
- **Testing complexity** - Need to test on multiple platforms

## The Solution: XPlatform's Unified API

XPlatform provides **type aliases** that automatically map to the correct platform type:

```swift
import XPlatform

// This works on ALL Apple platforms!
let view = XView()
let color = XColor.red
let font = XFont.xSystemFont(ofSize: 14, weight: .regular)
```

## Key Benefits

### 1. Write Once, Run Everywhere
```swift
// Instead of this mess:
#if os(macOS)
    let image = NSImage(named: "icon")
    view.setNeedsDisplay()
#else
    let image = UIImage(named: "icon")
    view.setNeedsLayout()
#endif

// Just write:
let image = XImage(named: "icon")
view.setNeedsLayout() // XPlatform handles the platform differences
```

### 2. Unified Behavior for Common Tasks
XPlatform doesn't just alias types - it provides **unified APIs** for common operations that differ between platforms:

```swift
// Gesture handling - same API on all platforms
view.addTapGesture(target: self, action: #selector(handleTap))

// Pasteboard access - consistent interface
let pasteboard = XPasteboard.xGeneral
pasteboard.xString = "Cross-platform clipboard!"

// File system - same properties everywhere
let documentsDir = XPlatform.documentsDirectory
```

### 3. SwiftUI Integration
XPlatform seamlessly integrates with SwiftUI:

```swift
struct MyView: View {
    let image: XImage // Can accept NSImage or UIImage
    
    var body: some View {
        Image(image) // XPlatform provides the conversion
            .foregroundColor(Color(XPlatform.labelColor)) // Adaptive colors
    }
}
```

## When to Use XPlatform

✅ **Perfect for:**
- Apps targeting both macOS and iOS
- Shared frameworks/libraries
- Cross-platform SwiftUI components
- Code that needs to work in widgets, extensions, or watch apps

❌ **Not needed for:**
- iOS-only or macOS-only apps
- Platform-specific features (e.g., Touch Bar, Apple Pencil)
- Low-level system programming

## Quick Example: Cross-Platform View Controller

Here's a view controller that works on both macOS and iOS without any conditional compilation:

```swift
import XPlatform

class MyViewController: XViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set adaptive background color
        view.backgroundColor = XPlatform.adaptiveTextBackgroundColor
        
        // Add gesture recognizer
        view.addTapGesture(target: self, action: #selector(viewTapped))
        
        // Work with fonts
        let titleFont = XFont.xSystemFont(ofSize: 24, weight: .bold)
        
        // Access file system
        let cachesDir = XPlatform.cachesDirectory
        print("Caches at: \(cachesDir)")
    }
    
    @objc func viewTapped() {
        // Copy to clipboard
        XPasteboard.xGeneral.xString = "Tapped at \(Date())"
    }
}
```

## Common Pitfalls and Solutions

### 1. **Name Conflicts**
Some properties exist on both platforms but behave differently. XPlatform uses the 'x' prefix to avoid conflicts:
- Use `XFont.xSystemFontSize` instead of `systemFontSize`
- Use `XPasteboard.xGeneral` instead of `general`

### 2. **Coordinate Systems**
macOS and iOS use different coordinate systems. XPlatform helps you detect this:
```swift
if view.usesFlippedCoordinates {
    // Origin at top-left (iOS always, macOS sometimes)
} else {
    // Origin at bottom-left (macOS default)
}
```

### 3. **Missing APIs**
Some APIs only exist on one platform. XPlatform provides unified alternatives:
```swift
// setNeedsLayout() doesn't exist on macOS, but XPlatform adds it
view.setNeedsLayout() // Works everywhere!
```

## More Real-World Examples

### Example 1: Image Loading and Processing
```swift
import XPlatform

class ImageProcessor {
    func loadAndProcessImage(named name: String) -> XImage? {
        // Load image - works on all platforms
        guard let image = XImage(named: name) else { return nil }
        
        // Convert to JPEG data - XPlatform provides unified API
        #if os(macOS)
        let jpegData = image.jpegData(compressionQuality: 0.8)
        #else
        let jpegData = image.jpegData(compressionQuality: 0.8)
        #endif
        
        // Process the data...
        return image
    }
}
```

### Example 2: Building a Cross-Platform Color Palette
```swift
import XPlatform

struct AppTheme {
    // These colors adapt to dark/light mode on all platforms
    static let background = XPlatform.adaptiveTextBackgroundColor
    static let primaryText = XPlatform.labelColor
    static let secondaryText = XPlatform.secondaryLabelColor
    static let divider = XPlatform.separatorColor
    
    // Custom semantic colors
    static let success = XColor.systemGreen
    static let warning = XColor.systemOrange
    static let error = XColor.systemRed
    
    // Platform-adaptive tints
    static var accentColor: XColor {
        #if os(macOS)
        return NSColor.controlAccentColor
        #else
        return UIColor.tintColor
        #endif
    }
}
```

### Example 3: Cross-Platform Collection View
```swift
import XPlatform

class PhotoGridViewController: XViewController {
    var collectionView: XCollectionView!
    var dataSource: XCollectionViewDiffableDataSource<Section, Photo>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    func setupCollectionView() {
        // Create layout - same code for all platforms
        let layout = createGridLayout()
        
        // Initialize collection view
        collectionView = XCollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = XPlatform.secondaryBackgroundColor
        
        // Add to view hierarchy
        view.addSubview(collectionView)
        
        // Setup constraints (using your preferred method)
        setupConstraints()
    }
    
    func createGridLayout() -> XCollectionViewLayout {
        // Your layout code here - works on both platforms
        #if os(macOS)
        let layout = NSCollectionViewFlowLayout()
        layout.itemSize = NSSize(width: 150, height: 150)
        #else
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 150)
        #endif
        return layout
    }
}
```

### Example 4: Responder Chain and Event Handling
```swift
import XPlatform

class CustomTextField: XView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView() {
        // Make this view focusable
        #if os(macOS)
        self.acceptsFirstResponder = true
        #else
        self.isUserInteractionEnabled = true
        #endif
        
        // Add gestures
        addTapGesture(target: self, action: #selector(handleTap))
    }
    
    @objc func handleTap() {
        // Become first responder on tap
        makeFirstResponder()
    }
    
    func endEditing() {
        // Resign first responder
        resignFirstResponder()
    }
    
    // Handle keyboard events
    override var canBecomeFirstResponder: Bool {
        return true
    }
}
```

### Example 5: Cross-Platform Context Menus
```swift
import XPlatform

class DocumentView: XView {
    func setupContextMenu() {
        #if os(macOS)
        // macOS: Create NSMenu
        let menu = XMenu()
        menu.addItem(NSMenuItem(title: "Copy", action: #selector(copy(_:)), keyEquivalent: "c"))
        menu.addItem(NSMenuItem(title: "Paste", action: #selector(paste(_:)), keyEquivalent: "v"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Delete", action: #selector(delete(_:)), keyEquivalent: ""))
        
        self.addContextMenu(menu)
        #else
        // iOS 13+: Create UIMenu
        if #available(iOS 13.0, *) {
            self.addContextMenu {
                let copy = UIAction(title: "Copy", image: UIImage(systemName: "doc.on.doc")) { _ in
                    self.performCopy()
                }
                let paste = UIAction(title: "Paste", image: UIImage(systemName: "doc.on.clipboard")) { _ in
                    self.performPaste()
                }
                let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                    self.performDelete()
                }
                
                return UIMenu(children: [copy, paste, delete])
            }
        }
        #endif
    }
    
    func performCopy() {
        XPasteboard.xGeneral.xString = "Copied content"
    }
    
    func performPaste() {
        if let content = XPasteboard.xGeneral.xString {
            print("Pasted: \(content)")
        }
    }
    
    func performDelete() {
        // Delete implementation
    }
}
```

### Example 6: File Manager Operations
```swift
import XPlatform

class DocumentManager {
    // Save user preferences
    func savePreferences(_ prefs: [String: Any]) throws {
        let prefsURL = XPlatform.applicationSupportDirectory
            .appendingPathComponent("MyApp")
            .appendingPathComponent("preferences.plist")
        
        // Create directory if needed
        try FileManager.default.createDirectory(
            at: prefsURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        
        // Save preferences
        let data = try PropertyListSerialization.data(fromPropertyList: prefs, format: .xml, options: 0)
        try data.write(to: prefsURL)
    }
    
    // Cache downloaded images
    func cacheImage(_ imageData: Data, named name: String) throws {
        let cacheURL = XPlatform.cachesDirectory
            .appendingPathComponent("Images")
            .appendingPathComponent("\(name).jpg")
        
        try FileManager.default.createDirectory(
            at: cacheURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        
        try imageData.write(to: cacheURL)
    }
    
    // Clean up temporary files
    func cleanupTempFiles() {
        let tempDir = XPlatform.temporaryDirectory
        if let contents = try? FileManager.default.contentsOfDirectory(at: tempDir, includingPropertiesForKeys: nil) {
            for file in contents {
                try? FileManager.default.removeItem(at: file)
            }
        }
    }
}
```

### Example 7: SwiftUI Cross-Platform Component
```swift
import SwiftUI
import XPlatform

struct CrossPlatformButton: View {
    let title: String
    let action: () -> Void
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: CGFloat(XFont.xSystemFontSize)))
                .foregroundColor(Color(XPlatform.labelColor))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(isHovered ? XPlatform.tertiaryBackgroundColor : XPlatform.secondaryBackgroundColor))
                )
        }
        .buttonStyle(PlainButtonStyle())
        #if os(macOS)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
        #endif
    }
}

// Usage
struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            CrossPlatformButton(title: "Primary Action") {
                print("Primary tapped")
            }
            .primaryButtonStyle()
            
            CrossPlatformButton(title: "Secondary Action") {
                print("Secondary tapped")
            }
            .secondaryButtonStyle()
            
            CrossPlatformButton(title: "Link Style") {
                print("Link tapped")
            }
            .linkButtonStyle()
        }
        .padding()
        .background(Color(XPlatform.primaryBackgroundColor))
    }
}
```

## Next Steps

1. **Install XPlatform** via Swift Package Manager
2. **Replace platform-specific types** with X-prefixed equivalents
3. **Use XPlatform's unified APIs** for common operations
4. **Remove conditional compilation** where possible
5. **Test on all target platforms** to ensure consistency

Remember: XPlatform is a **bridge**, not a complete abstraction. For platform-specific features, you'll still need conditional compilation. But for 80% of your code, XPlatform lets you write once and run everywhere.

## Contributing

Found a common cross-platform pattern that's not in XPlatform? Contributions are welcome! The best additions are:
- Common UI patterns that exist on all platforms but with different APIs
- Frequently-used type aliases
- Helper methods that unify platform-specific behaviors