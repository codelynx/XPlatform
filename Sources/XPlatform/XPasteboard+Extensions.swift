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
	/// Returns the general/system pasteboard
	public static var xGeneral: XPasteboard {
		#if canImport(AppKit)
		return NSPasteboard.general
		#else
		return UIPasteboard.general
		#endif
	}
	
	/// Gets or sets the string content of the pasteboard
	public var xString: String? {
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