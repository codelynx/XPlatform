//
//  XColor+Extensions.swift
//  XPlatform
//
//  Cross-platform color extensions and semantic color mappings
//

import Foundation
import SwiftUI

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension XColor {
	#if canImport(AppKit)
	// MARK: - Background Colors
	
	/// Maps to iOS's systemBackground - the standard background color for views and windows
	public static var systemBackground: XColor {
		return .windowBackgroundColor
	}
	
	/// Maps to iOS's secondarySystemBackground - for content layered on top of the main background
	public static var secondarySystemBackground: XColor {
		return .controlBackgroundColor
	}
	
	/// Maps to iOS's tertiarySystemBackground - for content layered on top of secondary backgrounds
	public static var tertiarySystemBackground: XColor {
		return .underPageBackgroundColor
	}
	
	/// Maps to iOS's systemGroupedBackground - background for grouped content
	public static var systemGroupedBackground: XColor {
		return .controlBackgroundColor
	}
	
	/// Maps to iOS's secondarySystemGroupedBackground
	public static var secondarySystemGroupedBackground: XColor {
		return .windowBackgroundColor
	}
	
	/// Maps to iOS's tertiarySystemGroupedBackground
	public static var tertiarySystemGroupedBackground: XColor {
		return .underPageBackgroundColor
	}
	
	// MARK: - Label Colors
	
	/// Maps to iOS's label - primary text color
	public static var label: XColor {
		return .labelColor
	}
	
	/// Maps to iOS's secondaryLabel - secondary text color
	public static var secondaryLabel: XColor {
		return .secondaryLabelColor
	}
	
	/// Maps to iOS's tertiaryLabel - tertiary text color
	public static var tertiaryLabel: XColor {
		return .tertiaryLabelColor
	}
	
	/// Maps to iOS's quaternaryLabel - quaternary text color
	public static var quaternaryLabel: XColor {
		return .quaternaryLabelColor
	}
	
	/// Maps to iOS's placeholderText - placeholder text in controls
	public static var placeholderText: XColor {
		return .placeholderTextColor
	}
	
	// MARK: - Fill Colors
	
	/// Maps to iOS's systemFill - for thin borders or divider lines
	public static var systemFill: XColor {
		return .unemphasizedSelectedContentBackgroundColor
	}
	
	/// Maps to iOS's secondarySystemFill
	public static var secondarySystemFill: XColor {
		return .unemphasizedSelectedContentBackgroundColor.withAlphaComponent(0.8)
	}
	
	/// Maps to iOS's tertiarySystemFill
	public static var tertiarySystemFill: XColor {
		return .unemphasizedSelectedContentBackgroundColor.withAlphaComponent(0.6)
	}
	
	/// Maps to iOS's quaternarySystemFill
	public static var quaternarySystemFill: XColor {
		return .unemphasizedSelectedContentBackgroundColor.withAlphaComponent(0.4)
	}
	
	// MARK: - Separator Colors
	
	/// Maps to iOS's separator - separator lines that automatically adapt to the context
	public static var separator: XColor {
		return .separatorColor
	}
	
	/// Maps to iOS's opaqueSeparator - separator lines that don't allow content to show through
	public static var opaqueSeparator: XColor {
		return .gridColor
	}
	
	// MARK: - Link Color
	
	/// Maps to iOS's link - text links
	public static var link: XColor {
		return .linkColor
	}
	
	// MARK: - Selection Colors
	
	/// Selected content background color
	public static var selectedContentBackground: XColor {
		return .selectedContentBackgroundColor
	}
	
	/// Unemphasized selected content background
	public static var unemphasizedSelectedContentBackground: XColor {
		return .unemphasizedSelectedContentBackgroundColor
	}
	
	/// Selected text background color
	public static var selectedTextBackground: XColor {
		return .selectedTextBackgroundColor
	}
	
	/// Selected control color (respects accent color)
	public static var selectedControl: XColor {
		return .selectedControlColor
	}
	
	/// Alternate selected control color for lists
	public static var alternateSelectedControl: XColor {
		if #available(macOS 11.0, *) {
			return .unemphasizedSelectedContentBackgroundColor
		} else {
			return .alternateSelectedControlColor
		}
	}
	
	// MARK: - Control Colors
	
	/// Text color for controls
	public static var controlText: XColor {
		return .controlTextColor
	}
	
	/// Disabled control text color
	public static var disabledControlText: XColor {
		return .disabledControlTextColor
	}
	
	/// Control background color
	public static var controlBackground: XColor {
		return .controlBackgroundColor
	}
	
	/// Text background color (for text fields)
	public static var textBackground: XColor {
		return .textBackgroundColor
	}
	
	// MARK: - System Colors
	// Note: macOS 10.14+ already provides systemBlue, systemGreen, etc. natively
	// including systemGray, so we don't need to redefine them here
	
	// MARK: - Gray Colors
	
	/// Maps to iOS's systemGray2
	public static var systemGray2: XColor {
		return .darkGray
	}
	
	/// Maps to iOS's systemGray3
	public static var systemGray3: XColor {
		return .gray
	}
	
	/// Maps to iOS's systemGray4
	public static var systemGray4: XColor {
		return .gray.withAlphaComponent(0.8)
	}
	
	/// Maps to iOS's systemGray5
	public static var systemGray5: XColor {
		return .lightGray
	}
	
	/// Maps to iOS's systemGray6
	public static var systemGray6: XColor {
		return .lightGray.withAlphaComponent(0.8)
	}
	
	#else
	// iOS already has these properties natively
	#endif
	
	// MARK: - Cross-platform Semantic Colors
	
	/// Accent/tint color that respects user preferences
	public static var accent: XColor {
		#if canImport(AppKit)
		if #available(macOS 10.14, *) {
			return .controlAccentColor
		} else {
			return .selectedControlColor
		}
		#else
		if #available(iOS 14.0, *) {
			return .tintColor
		} else {
			return .systemBlue
		}
		#endif
	}
	
	/// Window/view background color
	public static var windowBackground: XColor {
		#if canImport(AppKit)
		return .windowBackgroundColor
		#else
		return .systemBackground
		#endif
	}
	
	/// Control background color
	public static var xControlBackground: XColor {
		#if canImport(AppKit)
		return .controlBackgroundColor
		#else
		return .secondarySystemBackground
		#endif
	}
	
	/// Primary label/text color
	public static var xLabel: XColor {
		#if canImport(AppKit)
		return .labelColor
		#else
		return .label
		#endif
	}
	
	/// Secondary label color
	public static var xSecondaryLabel: XColor {
		#if canImport(AppKit)
		return .secondaryLabelColor
		#else
		return .secondaryLabel
		#endif
	}
	
	/// Tertiary label color
	public static var xTertiaryLabel: XColor {
		#if canImport(AppKit)
		return .tertiaryLabelColor
		#else
		return .tertiaryLabel
		#endif
	}
	
	/// Separator color
	public static var xSeparator: XColor {
		#if canImport(AppKit)
		return .separatorColor
		#else
		return .separator
		#endif
	}
	
	/// Link color
	public static var xLink: XColor {
		#if canImport(AppKit)
		return .linkColor
		#else
		return .link
		#endif
	}
	
	/// Grid/table line color
	public static var xGrid: XColor {
		#if canImport(AppKit)
		return .gridColor
		#else
		return .separator
		#endif
	}
	
	/// Placeholder text color
	public static var xPlaceholderText: XColor {
		#if canImport(AppKit)
		return .placeholderTextColor
		#else
		return .placeholderText
		#endif
	}
	
	/// Selected/highlighted content background
	public static var xSelectedContentBackground: XColor {
		#if canImport(AppKit)
		return .selectedContentBackgroundColor
		#else
		if #available(iOS 14.0, *) {
			return .tintColor.withAlphaComponent(0.3)
		} else {
			return .systemBlue.withAlphaComponent(0.3)
		}
		#endif
	}
	
	/// Disabled text color
	public static var xDisabledText: XColor {
		#if canImport(AppKit)
		return .disabledControlTextColor
		#else
		return .tertiaryLabel
		#endif
	}
	
	// MARK: - Purpose-Specific Color Helpers
	
	/// Returns the appropriate color for interactive elements (buttons, links, etc.)
	public static func colorForInteractiveElement() -> XColor {
		return XColor.accent
	}
	
	/// Returns the appropriate color for success states (checkmarks, success messages)
	public static func colorForSuccess() -> XColor {
		#if canImport(AppKit)
		if #available(macOS 10.14, *) {
			return .systemGreen
		} else {
			return .green
		}
		#else
		return .systemGreen
		#endif
	}
	
	/// Returns the appropriate color for warning states
	public static func colorForWarning() -> XColor {
		#if canImport(AppKit)
		if #available(macOS 10.14, *) {
			return .systemOrange
		} else {
			return .orange
		}
		#else
		return .systemOrange
		#endif
	}
	
	/// Returns the appropriate color for error/destructive states
	public static func colorForError() -> XColor {
		#if canImport(AppKit)
		if #available(macOS 10.14, *) {
			return .systemRed
		} else {
			return .red
		}
		#else
		return .systemRed
		#endif
	}
	
	/// Returns the appropriate color for informational states
	public static func colorForInfo() -> XColor {
		#if canImport(AppKit)
		if #available(macOS 10.14, *) {
			return .systemBlue
		} else {
			return .blue
		}
		#else
		return .systemBlue
		#endif
	}
	
	/// Returns the appropriate color for disabled/inactive states
	public static func colorForDisabledState() -> XColor {
		return xDisabledText
	}
	
	/// Returns the appropriate color for placeholder content
	public static func colorForPlaceholder() -> XColor {
		return xPlaceholderText
	}
	
	/// Returns the appropriate color for selected/highlighted content
	public static func colorForSelection() -> XColor {
		return xSelectedContentBackground
	}
}