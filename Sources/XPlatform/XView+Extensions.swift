//
//  XView+Extensions.swift
//  XPlatform
//
//  Cross-platform view extensions for layout, responders, gestures, and appearance
//

import Foundation
import SwiftUI

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

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
	
	// MARK: - Layout Helpers
	
	/// Creates a transform from this view's coordinate space to another view's coordinate space
	public func transform(to view: XView) -> CGAffineTransform {
		let targetRect: CGRect = self.convert(self.bounds, to: view)
		return view.bounds.transform(to: targetRect)
	}
	
	/// Adds a subview and constrains it to fill this view
	public func addSubviewToFit(_ view: XView) {
		view.frame = self.bounds
		self.addSubview(view)
		view.translatesAutoresizingMaskIntoConstraints = false
		
		#if canImport(AppKit)
		NSLayoutConstraint.activate([
			view.topAnchor.constraint(equalTo: self.topAnchor),
			view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			view.trailingAnchor.constraint(equalTo: self.trailingAnchor)
		])
		#else
		NSLayoutConstraint.activate([
			view.topAnchor.constraint(equalTo: self.topAnchor),
			view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			view.leftAnchor.constraint(equalTo: self.leftAnchor),
			view.rightAnchor.constraint(equalTo: self.rightAnchor)
		])
		#endif
	}
	
	// MARK: - Border Support
	
	/// Sets the border color and width for the view
	public func setBorder(color: XColor?, width: CGFloat) {
		#if canImport(AppKit)
		self.wantsLayer = true
		self.layer?.borderWidth = width
		self.layer?.borderColor = color?.cgColor
		#else
		self.layer.borderWidth = width
		self.layer.borderColor = color?.cgColor
		#endif
	}
	
	// MARK: - Responder Chain Helpers
	
	/// Finds the parent view controller in the responder chain
	public func findViewController() -> XViewController? {
		var responder = self.next
		while responder != nil {
			if let viewController = responder as? XViewController {
				return viewController
			}
			responder = responder?.next
		}
		return nil
	}
	
	/// Finds the first responder view in the view hierarchy
	public func firstResponderView() -> XView? {
		#if canImport(AppKit)
		// On macOS, check if this view is the first responder
		if self.window?.firstResponder == self {
			return self
		}
		// Check subviews
		for subview in self.subviews {
			if let firstResponder = subview.firstResponderView() {
				return firstResponder
			}
		}
		return nil
		#else
		// On iOS, use isFirstResponder property
		if self.isFirstResponder {
			return self
		}
		// Check subviews
		for subview in self.subviews {
			if let firstResponder = subview.firstResponderView() {
				return firstResponder
			}
		}
		return nil
		#endif
	}
}