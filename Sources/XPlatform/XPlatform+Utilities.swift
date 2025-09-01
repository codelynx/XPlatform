//
//  XPlatform+Utilities.swift
//  XPlatform
//
//  Cross-platform static utilities and resources
//

import Foundation

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

// MARK: - Cross-platform Colors and System Resources

public struct XPlatform {
	// MARK: - Colors
	
	#if canImport(AppKit)
	public static let primaryBackgroundColor = NSColor.controlBackgroundColor
	public static let secondaryBackgroundColor = NSColor.windowBackgroundColor
	public static let tertiaryBackgroundColor = NSColor.controlBackgroundColor
	#elseif canImport(UIKit)
	public static let primaryBackgroundColor = UIColor.systemBackground
	public static let secondaryBackgroundColor = UIColor.secondarySystemBackground
	public static let tertiaryBackgroundColor = UIColor.tertiarySystemBackground
	#endif
	
	/// Adaptive background color that works well for text views
	public static var adaptiveTextBackgroundColor: XColor {
		#if canImport(AppKit)
		return NSColor.textBackgroundColor
		#elseif canImport(UIKit)
		return UIColor.systemBackground
		#endif
	}
	
	/// Adaptive label color
	public static var labelColor: XColor {
		#if canImport(AppKit)
		return NSColor.labelColor
		#elseif canImport(UIKit)
		return UIColor.label
		#endif
	}
	
	/// Adaptive secondary label color
	public static var secondaryLabelColor: XColor {
		#if canImport(AppKit)
		return NSColor.secondaryLabelColor
		#elseif canImport(UIKit)
		return UIColor.secondaryLabel
		#endif
	}
	
	/// Adaptive separator color
	public static var separatorColor: XColor {
		#if canImport(AppKit)
		return NSColor.separatorColor
		#elseif canImport(UIKit)
		return UIColor.separator
		#endif
	}
	
	// MARK: - File System
	
	/// Returns the user's documents directory
	public static var documentsDirectory: URL {
		FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
	}
	
	/// Returns the application support directory
	public static var applicationSupportDirectory: URL {
		FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
	}
	
	/// Returns the caches directory
	public static var cachesDirectory: URL {
		FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
	}
	
	/// Returns the temporary directory
	public static var temporaryDirectory: URL {
		FileManager.default.temporaryDirectory
	}
}