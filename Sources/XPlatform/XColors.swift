//
//  XColors.swift
//  XPlatform
//
//  Canonical cross-platform background color tiers.
//  Use these to avoid `#if canImport(AppKit)` at call sites.
//

import SwiftUI

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

// MARK: - XColor (NSColor/UIColor)

extension XColor {
	/// Primary surface background.
	/// iOS: `systemBackground`. macOS: `windowBackgroundColor`.
	public static var primaryBackground: XColor {
		#if canImport(AppKit)
		return .windowBackgroundColor
		#else
		return .systemBackground
		#endif
	}

	/// Content layered on top of the primary surface.
	/// iOS: `secondarySystemBackground`. macOS: `controlBackgroundColor`.
	public static var secondaryBackground: XColor {
		#if canImport(AppKit)
		return .controlBackgroundColor
		#else
		return .secondarySystemBackground
		#endif
	}

	/// Content layered on top of the secondary surface.
	/// iOS: `tertiarySystemBackground`. macOS: `underPageBackgroundColor`.
	public static var tertiaryBackground: XColor {
		#if canImport(AppKit)
		return .underPageBackgroundColor
		#else
		return .tertiarySystemBackground
		#endif
	}
}

// MARK: - SwiftUI Color

extension Color {
	public static var primaryBackground: Color { Color(XColor.primaryBackground) }
	public static var secondaryBackground: Color { Color(XColor.secondaryBackground) }
	public static var tertiaryBackground: Color { Color(XColor.tertiaryBackground) }
}