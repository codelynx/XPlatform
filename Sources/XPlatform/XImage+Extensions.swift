//
//  XImage+Extensions.swift
//  XPlatform
//
//  Cross-platform image data and CGImage extensions
//

import Foundation
import SwiftUI

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension XImage {
	#if canImport(AppKit)
	public func jpegData(compressionQuality: CGFloat) -> Data? {
		guard let tiffData = self.tiffRepresentation,
		      let bitmap = NSBitmapImageRep(data: tiffData) else { return nil }
		return bitmap.representation(using: .jpeg, properties: [.compressionFactor: compressionQuality])
	}
	
	/// Returns the CGImage representation of this NSImage
	public var cgImage: CGImage? {
		guard let imageData = self.tiffRepresentation,
		      let source = CGImageSourceCreateWithData(imageData as CFData, nil),
		      let image = CGImageSourceCreateImageAtIndex(source, 0, nil) else {
			return nil
		}
		return image
	}
	#endif
	
	// Note: UIImage already has a cgImage property, no extension needed for UIKit
}