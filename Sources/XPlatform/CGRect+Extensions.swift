//
//  CGRect+Extensions.swift
//  XPlatform
//
//  Cross-platform CGRect transform utilities
//

#if canImport(CoreGraphics)
import Foundation
import CoreGraphics

extension CGRect {
	/// Creates a transform that maps this rectangle to the target rectangle.
	///
	/// Force-computes; divides by `self.width` and `self.height`, so a source
	/// rectangle with zero width or height produces an invalid transform.
	/// Use `transformIfValid(to:)` for a non-crashing variant.
	public func transform(to targetRect: CGRect) -> CGAffineTransform {
		// Calculate scale factors
		let scaleX = targetRect.width / self.width
		let scaleY = targetRect.height / self.height

		// Calculate translation
		let translateX = targetRect.minX - self.minX * scaleX
		let translateY = targetRect.minY - self.minY * scaleY

		// Create the combined transform
		var transform = CGAffineTransform.identity
		transform = transform.scaledBy(x: scaleX, y: scaleY)
		transform = transform.translatedBy(x: translateX / scaleX, y: translateY / scaleY)

		return transform
	}

	/// Creates a transform that maps this rectangle to the target rectangle,
	/// or `nil` if this rectangle has zero width or zero height (which would
	/// cause a divide-by-zero in the unchecked `transform(to:)`).
	///
	/// Negative dimensions are permitted — the math is valid as long as the
	/// divisor is nonzero.
	public func transformIfValid(to targetRect: CGRect) -> CGAffineTransform? {
		guard self.width != 0, self.height != 0 else { return nil }
		return transform(to: targetRect)
	}
}
#endif	
