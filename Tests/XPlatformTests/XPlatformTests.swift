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
}