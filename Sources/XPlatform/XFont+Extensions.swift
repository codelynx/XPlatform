//
//  XFont+Extensions.swift
//  XPlatform
//
//  Cross-platform font utilities.
//  NOTE: `XFont.systemFont(ofSize:weight:)`, `XFont.systemFontSize`,
//  `XFont.smallSystemFontSize`, and `XFont.labelFontSize` are all available
//  natively on both NSFont and UIFont — no cross-platform wrappers needed.
//

import Foundation

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif
