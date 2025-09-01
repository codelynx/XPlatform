//
//  SwiftUI+Extensions.swift
//  XPlatform
//
//  SwiftUI integration extensions
//

import SwiftUI

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

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