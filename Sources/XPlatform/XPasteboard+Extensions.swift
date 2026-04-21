//
//  XPasteboard+Extensions.swift
//  XPlatform
//
//  Cross-platform pasteboard/clipboard utilities
//

import Foundation

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension XPasteboard {
	/// Gets or sets the string content of the pasteboard.
	/// Unified name across `NSPasteboard` and `UIPasteboard`.
	public var stringValue: String? {
		get {
			#if canImport(AppKit)
			return self.string(forType: .string)
			#else
			return self.string
			#endif
		}
		set {
			#if canImport(AppKit)
			if let newValue = newValue {
				self.clearContents()
				self.setString(newValue, forType: .string)
			}
			#else
			self.string = newValue
			#endif
		}
	}
}