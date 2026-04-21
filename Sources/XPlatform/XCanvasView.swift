//
//  XCanvasView.swift
//  XPlatform
//
//  Coordinate-system primitives for cross-platform canvas / document views.
//
//  AppKit's `NSView` and `NSClipView` default to a bottom-left origin, while
//  UIKit uses top-left throughout. Subclassing these and returning `true`
//  from `isFlipped` aligns macOS with UIKit semantics. Once the content view
//  is flipped and its `bounds == scene.bounds`, native event APIs
//  (`UITouch.location(in:)`, `NSView.convert(_:from:)`) return scene
//  coordinates directly — no manual Y-flipping, offset math, or zoom math
//  required.
//
//  On iOS, `XCanvasView` is a typealias for `UIView` so call sites stay
//  portable without `#if`. `XCanvasClipView` is macOS-only — UIKit has no
//  `NSClipView` equivalent, so aliasing it would create false symmetry;
//  reference it behind `#if canImport(AppKit)`.
//

import Foundation

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)

/// An `NSView` subclass whose coordinate system is top-left origin, matching
/// UIKit. Use as the base class for any canvas / document / content view so
/// touch-to-content coordinate math works identically on macOS and iOS.
open class XCanvasView: NSView {
	open override var isFlipped: Bool { true }
}

/// An `NSClipView` subclass with top-left origin. Install on an
/// `NSScrollView` (via `scrollView.contentView = XCanvasClipView(...)`) to
/// extend the top-left convention into the clip layer as well.
open class XCanvasClipView: NSClipView {
	open override var isFlipped: Bool { true }
}

#elseif canImport(UIKit)

/// On UIKit, views are already top-left origin — `XCanvasView` is just
/// `UIView`. There is no UIKit equivalent of `NSClipView`, so
/// `XCanvasClipView` is intentionally not defined here.
public typealias XCanvasView = UIView

#endif
