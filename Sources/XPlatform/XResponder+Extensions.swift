//
//  XResponder+Extensions.swift
//  XPlatform
//
//  Cross-platform responder chain utilities
//

import Foundation

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public extension XResponder {
	
	/// Finds the first responder of the specified type in the responder chain
	@MainActor func findResponder<T>(of type: T.Type) -> T? {
		if let responder = self as? T {
			return responder
		} else {
			#if canImport(AppKit)
			return self.nextResponder?.findResponder(of: type)
			#else
			return self.next?.findResponder(of: type)
			#endif
		}
	}
	
	/// Returns the next responder in the chain (unified API for iOS/macOS)
	#if canImport(AppKit)
	@MainActor var next: XResponder? {
		return self.nextResponder
	}
	#endif
	
	/// Returns all responders in the chain as an array
	@MainActor var responders: [XResponder] {
		return self.map { $0 }
	}
}

// MARK: - Sequence Conformance

extension XResponder: @preconcurrency @retroactive Sequence {
	
	@MainActor public func makeIterator() -> Iterator {
		return Iterator(responder: self)
	}
	
	public struct Iterator: @preconcurrency IteratorProtocol {
		
		public typealias Element = XResponder
		private var responder: XResponder?
		
		@MainActor init(responder: XResponder) {
			self.responder = responder
		}
		
		@MainActor public mutating func next() -> XResponder? {
			let current = self.responder
			#if canImport(AppKit)
			self.responder = current?.nextResponder
			#else
			self.responder = current?.next
			#endif
			return current
		}
	}
}