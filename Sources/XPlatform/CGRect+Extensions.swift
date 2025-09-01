//
//  CGRect+Extensions.swift
//  XPlatform
//
//  Cross-platform CGRect transform utilities
//

import Foundation
import CoreGraphics

extension CGRect {
	/// Creates a transform that maps this rectangle to the target rectangle
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
}