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
	// For primary/secondary/tertiary backgrounds, use `XColor.primaryBackground` etc.

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
	//
	// Each standard directory has two accessors:
	//   - `xxxDirectory: URL` — convenience; force-unwraps internally. On iOS
	//     and macOS the lookup never fails in practice, but the force-unwrap
	//     remains a latent foot-gun for unusual sandbox / test-harness cases.
	//   - `xxxDirectoryIfAvailable: URL?` — safe variant; returns `nil` if
	//     the lookup has no result. Prefer this in new code.
	//
	// `temporaryDirectory` does not have an optional sibling because
	// `FileManager.default.temporaryDirectory` is a non-optional API.

	/// Returns the user's documents directory, or `nil` if the lookup yields no URL.
	public static var documentsDirectoryIfAvailable: URL? {
		FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
	}

	/// Returns the application support directory, or `nil` if the lookup yields no URL.
	public static var applicationSupportDirectoryIfAvailable: URL? {
		FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
	}

	/// Returns the caches directory, or `nil` if the lookup yields no URL.
	public static var cachesDirectoryIfAvailable: URL? {
		FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
	}

	/// Returns the user's documents directory. Force-unwraps the underlying
	/// `FileManager` lookup; prefer `documentsDirectoryIfAvailable` in new code.
	public static var documentsDirectory: URL {
		documentsDirectoryIfAvailable!
	}

	/// Returns the application support directory. Force-unwraps the underlying
	/// `FileManager` lookup; prefer `applicationSupportDirectoryIfAvailable` in new code.
	public static var applicationSupportDirectory: URL {
		applicationSupportDirectoryIfAvailable!
	}

	/// Returns the caches directory. Force-unwraps the underlying
	/// `FileManager` lookup; prefer `cachesDirectoryIfAvailable` in new code.
	public static var cachesDirectory: URL {
		cachesDirectoryIfAvailable!
	}

	/// Returns the temporary directory.
	public static var temporaryDirectory: URL {
		FileManager.default.temporaryDirectory
	}
}