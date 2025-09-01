//
//  XAlert+Extensions.swift
//  XPlatform
//
//  Cross-platform alert support
//

import Foundation

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

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