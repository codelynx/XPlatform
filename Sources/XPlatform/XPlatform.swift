//
//  XPlatform.swift
//  Photolala
//
//  Created by Kaz Yoshikawa on 2025/06/12.
//

import Foundation
import SwiftUI

#if canImport(AppKit)
	import AppKit
	public typealias XView = NSView
	public typealias XViewController = NSViewController
	public typealias XWindow = NSWindow
	public typealias XImage = NSImage
	public typealias XColor = NSColor
	public typealias XFont = NSFont
	public typealias XBezierPath = NSBezierPath
	public typealias XGestureRecognizer = NSGestureRecognizer
	public typealias XTapGestureRecognizer = NSClickGestureRecognizer
	public typealias XPanGestureRecognizer = NSPanGestureRecognizer
	public typealias XCollectionView = NSCollectionView
	public typealias XCollectionViewDelegate = NSCollectionViewDelegate
	public typealias XCollectionViewDataSource = NSCollectionViewDataSource
	public typealias XViewControllerRepresentable = NSViewControllerRepresentable
	public typealias XViewRepresentable = NSViewRepresentable
	public typealias XMenu = NSMenu
	public typealias XCollectionViewDiffableDataSource = NSCollectionViewDiffableDataSource
	public typealias XCollectionViewLayout = NSCollectionViewLayout
	public typealias XAlert = NSAlert
	public typealias XPasteboard = NSPasteboard
#endif

#if canImport(UIKit)
	import UIKit
	public typealias XView = UIView
	public typealias XViewController = UIViewController
	public typealias XWindow = UIWindow
	public typealias XImage = UIImage
	public typealias XColor = UIColor
	public typealias XFont = UIFont
	public typealias XBezierPath = UIBezierPath
	public typealias XGestureRecognizer = UIGestureRecognizer
	public typealias XTapGestureRecognizer = UITapGestureRecognizer
	public typealias XPanGestureRecognizer = UIPanGestureRecognizer
	public typealias XCollectionView = UICollectionView
	public typealias XCollectionViewDelegate = UICollectionViewDelegate
	public typealias XCollectionViewDataSource = UICollectionViewDataSource
	public typealias XViewControllerRepresentable = UIViewControllerRepresentable
	public typealias XViewRepresentable = UIViewRepresentable
	public typealias XMenu = UIMenu
	public typealias XCollectionViewDiffableDataSource = UICollectionViewDiffableDataSource
	public typealias XCollectionViewLayout = UICollectionViewLayout
	public typealias XAlert = UIAlertController
	public typealias XPasteboard = UIPasteboard
#endif

// MARK: - View Extensions

extension XView {
	#if canImport(AppKit)
	public func setNeedsLayout() {
		self.needsLayout = true
	}
	#elseif canImport(UIKit)
	// setNeedsLayout() already exists
	#endif
	
	/// Returns whether the view uses a flipped coordinate system
	public var usesFlippedCoordinates: Bool {
		#if canImport(AppKit)
		return self.isFlipped
		#else
		return true // iOS always uses top-left origin
		#endif
	}
	
	/// Makes this view the first responder
	public func makeFirstResponder() {
		#if canImport(AppKit)
		self.window?.makeFirstResponder(self)
		#else
		self.becomeFirstResponder()
		#endif
	}
	
	/// Resigns first responder status
	public func resignFirstResponder() {
		#if canImport(AppKit)
		if self.window?.firstResponder == self {
			self.window?.makeFirstResponder(nil)
		}
		#else
		_ = super.resignFirstResponder()
		#endif
	}
	
	/// Adds a tap gesture recognizer
	public func addTapGesture(target: Any?, action: Selector) {
		#if canImport(AppKit)
		let gesture = NSClickGestureRecognizer(target: target, action: action)
		#else
		let gesture = UITapGestureRecognizer(target: target, action: action)
		#endif
		self.addGestureRecognizer(gesture)
	}
	
	/// Adds a tap gesture recognizer with tap count
	public func addTapGesture(target: Any?, action: Selector, taps: Int) {
		#if canImport(AppKit)
		let gesture = NSClickGestureRecognizer(target: target, action: action)
		gesture.numberOfClicksRequired = taps
		#else
		let gesture = UITapGestureRecognizer(target: target, action: action)
		gesture.numberOfTapsRequired = taps
		#endif
		self.addGestureRecognizer(gesture)
	}
	
	/// Adds a pan gesture recognizer
	public func addPanGesture(target: Any?, action: Selector) {
		let gesture = XPanGestureRecognizer(target: target, action: action)
		self.addGestureRecognizer(gesture)
	}
	
	// MARK: - Tint Color Support
	
	/// Gets or sets the tint color for the view
	/// On macOS, this uses the effectiveAppearance and controlAccentColor
	/// On iOS, this uses the native tintColor property
	public var xTintColor: XColor? {
		get {
			#if canImport(AppKit)
			if #available(macOS 10.14, *) {
				return NSColor.controlAccentColor
			} else {
				return NSColor.selectedControlColor
			}
			#else
			return self.tintColor
			#endif
		}
		set {
			#if canImport(AppKit)
			// On macOS, we can't directly set a tint color on NSView
			// This would need to be handled by subviews or custom drawing
			// Store it as an associated object if needed
			#else
			if let color = newValue {
				self.tintColor = color
			}
			#endif
		}
	}
	
	/// Returns the effective tint color, traversing up the view hierarchy if needed
	public var effectiveTintColor: XColor {
		#if canImport(AppKit)
		if #available(macOS 10.14, *) {
			return NSColor.controlAccentColor
		} else {
			return NSColor.selectedControlColor
		}
		#else
		return self.tintColor
		#endif
	}
	
	// MARK: - Purpose-Specific Colors
	
	/// Returns an appropriate background color for this view based on its context
	public var appropriateBackgroundColor: XColor {
		#if canImport(AppKit)
		// Check if this is a control or a regular view
		if self is NSControl {
			return .controlBackgroundColor
		} else if self.superview == nil {
			return .windowBackgroundColor
		} else {
			return .controlBackgroundColor
		}
		#else
		// iOS views typically use clear background unless specified
		if self.superview == nil {
			return .systemBackground
		} else {
			return .secondarySystemBackground
		}
		#endif
	}
	
	/// Returns an appropriate text/label color for content in this view
	public var appropriateLabelColor: XColor {
		#if canImport(AppKit)
		if self is NSControl {
			return .controlTextColor
		} else {
			return .labelColor
		}
		#else
		return .label
		#endif
	}
	
	/// Returns an appropriate border/stroke color for this view
	public var appropriateBorderColor: XColor {
		#if canImport(AppKit)
		return .separatorColor
		#else
		return .separator
		#endif
	}
	
	/// Returns an appropriate highlight/selection color for this view
	public var appropriateSelectionColor: XColor {
		#if canImport(AppKit)
		if #available(macOS 10.14, *) {
			return .selectedContentBackgroundColor
		} else {
			return .selectedControlColor
		}
		#else
		return self.tintColor.withAlphaComponent(0.3)
		#endif
	}
}

// Cross-platform image data extension
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

// MARK: - Image Extension

extension Image {
	public init(_ image: XImage) {
		#if canImport(AppKit)
		self.init(nsImage: image)
		#elseif canImport(UIKit)
		self.init(uiImage: image)
		#endif
	}
}


// MARK: - Cross-platform Button Styles

extension View {
	/// Applies a link-style button appearance across platforms
	public func linkButtonStyle() -> some View {
		#if canImport(AppKit)
		self.buttonStyle(.link)
		#elseif canImport(UIKit)
		self.buttonStyle(.plain)
			.foregroundColor(.blue)
		#endif
	}
	
	/// Applies a primary button style across platforms
	public func primaryButtonStyle() -> some View {
		#if canImport(AppKit)
		self.buttonStyle(.borderedProminent)
		#elseif canImport(UIKit)
		self.buttonStyle(.borderedProminent)
		#endif
	}
	
	/// Applies a secondary button style across platforms
	public func secondaryButtonStyle() -> some View {
		#if canImport(AppKit)
		self.buttonStyle(.bordered)
		#elseif canImport(UIKit)
		self.buttonStyle(.bordered)
		#endif
	}
}

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

// MARK: - XColor Extensions

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

// MARK: - Font Extensions

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

// MARK: - Pasteboard Extensions

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

// MARK: - Context Menu Support

#if canImport(UIKit)
public typealias XContextMenuConfiguration = UIContextMenuConfiguration
#endif

extension XView {
	/// Adds a context menu to the view
	#if canImport(AppKit)
	public func addContextMenu(_ menu: XMenu) {
		self.menu = menu
	}
	#else
	@available(iOS 13.0, *)
	public func addContextMenu(provider: @escaping () -> XMenu?) {
		let interaction = UIContextMenuInteraction(delegate: ContextMenuDelegate(provider: provider))
		self.addInteraction(interaction)
	}
	#endif
}

#if canImport(UIKit)
@available(iOS 13.0, *)
private class ContextMenuDelegate: NSObject, UIContextMenuInteractionDelegate {
	let provider: () -> UIMenu?
	
	init(provider: @escaping () -> UIMenu?) {
		self.provider = provider
	}
	
	func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
		return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
			return self.provider()
		}
	}
}
#endif

// MARK: - Alert Support

public struct XAlertStyle {
	public static let informational = 0
	public static let warning = 1
	public static let critical = 2
}

extension XAlert {
	/// Shows a simple alert with a message
	public static func showAlert(title: String, message: String, style: Int = XAlertStyle.informational) {
		#if canImport(AppKit)
		let alert = NSAlert()
		alert.messageText = title
		alert.informativeText = message
		switch style {
		case XAlertStyle.warning:
			alert.alertStyle = .warning
		case XAlertStyle.critical:
			alert.alertStyle = .critical
		default:
			alert.alertStyle = .informational
		}
		alert.runModal()
		#else
		// On iOS, this would need to be presented from a view controller
		// This is a simplified version - in practice you'd need the presenting VC
		print("Alert: \(title) - \(message)")
		#endif
	}
}
