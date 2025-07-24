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
    
    func testXPlatformColors() throws {
        XCTAssertNotNil(XPlatform.primaryBackgroundColor)
        XCTAssertNotNil(XPlatform.secondaryBackgroundColor)
        XCTAssertNotNil(XPlatform.tertiaryBackgroundColor)
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
        let font = XFont.xSystemFont(ofSize: 14, weight: .regular)
        XCTAssertNotNil(font)
        
        XCTAssertGreaterThan(XFont.xSystemFontSize, 0)
        XCTAssertGreaterThan(XFont.xSmallSystemFontSize, 0)
        XCTAssertGreaterThan(XFont.xLabelFontSize, 0)
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
        let pasteboard = XPasteboard.xGeneral
        XCTAssertNotNil(pasteboard)
        
        // Test string operations
        let testString = "XPlatform Test String"
        pasteboard.xString = testString
        
        #if os(macOS)
        // On macOS, we can verify the string was set
        XCTAssertEqual(pasteboard.xString, testString)
        #endif
    }
    
    func testAlertStyles() throws {
        XCTAssertEqual(XAlertStyle.informational, 0)
        XCTAssertEqual(XAlertStyle.warning, 1)
        XCTAssertEqual(XAlertStyle.critical, 2)
    }
    
    @objc private func dummyAction() {
        // Dummy selector for testing
    }
}