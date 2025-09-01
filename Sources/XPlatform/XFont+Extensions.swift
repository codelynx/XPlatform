//
//  XFont+Extensions.swift
//  XPlatform
//
//  Cross-platform font utilities
//

import Foundation
import SwiftUI

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension XFont {
	/// Creates a cross-platform system font with the specified size and weight
	public static func xSystemFont(ofSize size: CGFloat, weight: XFont.Weight) -> XFont {
		#if canImport(AppKit)
		return NSFont.systemFont(ofSize: size, weight: weight)
		#else
		return UIFont.systemFont(ofSize: size, weight: weight)
		#endif
	}
	
	/// Returns the default system font size
	public static var xSystemFontSize: CGFloat {
		#if canImport(AppKit)
		return NSFont.systemFontSize
		#else
		return UIFont.systemFontSize
		#endif
	}
	
	/// Returns the default small system font size
	public static var xSmallSystemFontSize: CGFloat {
		#if canImport(AppKit)
		return NSFont.smallSystemFontSize
		#else
		return UIFont.smallSystemFontSize
		#endif
	}
	
	/// Returns the default label font size
	public static var xLabelFontSize: CGFloat {
		#if canImport(AppKit)
		return NSFont.labelFontSize
		#else
		return UIFont.labelFontSize
		#endif
	}
}