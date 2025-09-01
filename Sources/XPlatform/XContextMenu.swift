//
//  XContextMenu.swift
//  XPlatform
//
//  Cross-platform context menu support
//

import Foundation

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
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