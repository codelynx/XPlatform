import XCTest
@testable import XPlatform

final class XPlatformTests: XCTestCase {
    func testImageInitialization() throws {
        #if os(macOS)
        let image = XImage(size: NSSize(width: 100, height: 100))
        #else
        let image = XImage(size: CGSize(width: 100, height: 100))
        #endif
        
        XCTAssertNotNil(image)
    }
    
    func testBackgroundTiers() throws {
        XCTAssertNotNil(XColor.primaryBackground)
        XCTAssertNotNil(XColor.secondaryBackground)
        XCTAssertNotNil(XColor.tertiaryBackground)
    }
    
    func testAdaptiveColors() throws {
        XCTAssertNotNil(XPlatform.adaptiveTextBackgroundColor)
        XCTAssertNotNil(XPlatform.labelColor)
        XCTAssertNotNil(XPlatform.secondaryLabelColor)
        XCTAssertNotNil(XPlatform.separatorColor)
    }
    
    func testFileSystemDirectories() throws {
        XCTAssertNotNil(XPlatform.documentsDirectory)
        XCTAssertNotNil(XPlatform.applicationSupportDirectory)
        XCTAssertNotNil(XPlatform.cachesDirectory)
        XCTAssertNotNil(XPlatform.temporaryDirectory)
        
        // Verify they are valid URLs
        XCTAssertTrue(XPlatform.documentsDirectory.isFileURL)
        XCTAssertTrue(XPlatform.applicationSupportDirectory.isFileURL)
        XCTAssertTrue(XPlatform.cachesDirectory.isFileURL)
        XCTAssertTrue(XPlatform.temporaryDirectory.isFileURL)
    }
    
    func testFontMethods() throws {
        let font = XFont.systemFont(ofSize: 14, weight: .regular)
        XCTAssertNotNil(font)

        XCTAssertGreaterThan(XFont.systemFontSize, 0)
        XCTAssertGreaterThan(XFont.smallSystemFontSize, 0)
        XCTAssertGreaterThan(XFont.labelFontSize, 0)
    }
    
    func testViewExtensions() throws {
        let view = XView()
        
        // Test coordinate system
        #if os(macOS)
        XCTAssertFalse(view.usesFlippedCoordinates) // Default NSView is not flipped
        #else
        XCTAssertTrue(view.usesFlippedCoordinates) // iOS always uses flipped
        #endif
        
        // Test gesture addition (just verify it doesn't crash)
        view.addTapGesture(target: nil, action: #selector(dummyAction))
        view.addTapGesture(target: nil, action: #selector(dummyAction), taps: 2)
        view.addTapGesture(target: nil, action: #selector(dummyAction), taps: 3)
        view.addPanGesture(target: nil, action: #selector(dummyAction))
    }
    
    func testPasteboard() throws {
        let pasteboard = XPasteboard.general
        XCTAssertNotNil(pasteboard)
        
        // Test string operations
        let testString = "XPlatform Test String"
        pasteboard.stringValue = testString

        #if os(macOS)
        // On macOS, we can verify the string was set
        XCTAssertEqual(pasteboard.stringValue, testString)
        #endif
    }
    
    func testAlertStyles() throws {
        XCTAssertEqual(XAlertStyle.informational, 0)
        XCTAssertEqual(XAlertStyle.warning, 1)
        XCTAssertEqual(XAlertStyle.critical, 2)
    }

    @MainActor
    func testCanvasViewFlipsOnMac() throws {
        // Subclassing XCanvasView must compile on both platforms, and the
        // instance must report top-left origin on macOS. On iOS, UIView is
        // already top-left, so there's nothing to assert beyond "it compiles."
        final class CanvasContentView: XCanvasView {}
        let view = CanvasContentView()

        #if os(macOS)
        XCTAssertTrue(view.isFlipped, "XCanvasView must be top-left on macOS")

        let clip = XCanvasClipView()
        XCTAssertTrue(clip.isFlipped, "XCanvasClipView must be top-left on macOS")
        _ = clip
        #endif
        _ = view
    }

    @MainActor
    func testDocsExamplesCompile() throws {
        // Mirrors the README / GETTING_STARTED examples — if any of these stop
        // compiling, the docs need to be fixed to match.
        let view = XView()
        view.backgroundColor = .primaryBackground

        #if os(macOS)
        let cv = XCollectionView()
        cv.backgroundColor = .secondaryBackground
        #else
        let layout = UICollectionViewFlowLayout()
        let cv = XCollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .secondaryBackground
        #endif
        _ = (view, cv)
    }
    
    @objc private func dummyAction() {
        // Dummy selector for testing
    }
}