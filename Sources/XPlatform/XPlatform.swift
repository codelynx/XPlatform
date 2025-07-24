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
		_ = self.resignFirstResponder()
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
}

// Cross-platform image data extension
extension XImage {

	#if canImport(AppKit)
		func jpegData(compressionQuality: CGFloat) -> Data? {
			guard let tiffData = self.tiffRepresentation,
			      let bitmap = NSBitmapImageRep(data: tiffData) else { return nil }
			return bitmap.representation(using: .jpeg, properties: [.compressionFactor: compressionQuality])
		}
	#endif
}

// MARK: - Image Extension

extension Image {
	init(_ image: XImage) {
		#if os(macOS)
		self.init(nsImage: image)
		#else
		self.init(uiImage: image)
		#endif
	}
}


// MARK: - Cross-platform Button Styles

extension View {
	/// Applies a link-style button appearance across platforms
	func linkButtonStyle() -> some View {
		#if os(macOS)
		self.buttonStyle(.link)
		#else
		self.buttonStyle(.plain)
			.foregroundColor(.blue)
		#endif
	}
	
	/// Applies a primary button style across platforms
	func primaryButtonStyle() -> some View {
		#if os(macOS)
		self.buttonStyle(.borderedProminent)
		#else
		self.buttonStyle(.borderedProminent)
		#endif
	}
	
	/// Applies a secondary button style across platforms
	func secondaryButtonStyle() -> some View {
		#if os(macOS)
		self.buttonStyle(.bordered)
		#else
		self.buttonStyle(.bordered)
		#endif
	}
}

// MARK: - Cross-platform Colors and System Resources

public struct XPlatform {
	// MARK: - Colors
	
	#if os(macOS)
	public static let primaryBackgroundColor = NSColor.controlBackgroundColor
	public static let secondaryBackgroundColor = NSColor.windowBackgroundColor
	public static let tertiaryBackgroundColor = NSColor.controlBackgroundColor
	#else
	public static let primaryBackgroundColor = UIColor.systemBackground
	public static let secondaryBackgroundColor = UIColor.secondarySystemBackground
	public static let tertiaryBackgroundColor = UIColor.tertiarySystemBackground
	#endif
	
	/// Adaptive background color that works well for text views
	public static var adaptiveTextBackgroundColor: XColor {
		#if os(macOS)
		return NSColor.textBackgroundColor
		#else
		return UIColor.systemBackground
		#endif
	}
	
	/// Adaptive label color
	public static var labelColor: XColor {
		#if os(macOS)
		return NSColor.labelColor
		#else
		return UIColor.label
		#endif
	}
	
	/// Adaptive secondary label color
	public static var secondaryLabelColor: XColor {
		#if os(macOS)
		return NSColor.secondaryLabelColor
		#else
		return UIColor.secondaryLabel
		#endif
	}
	
	/// Adaptive separator color
	public static var separatorColor: XColor {
		#if os(macOS)
		return NSColor.separatorColor
		#else
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
