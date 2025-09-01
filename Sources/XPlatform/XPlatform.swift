//
//  XPlatform.swift
//  XPlatform
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
	public typealias XResponder = NSResponder
	public typealias XScrollView = NSScrollView
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
	public typealias XResponder = UIResponder
	public typealias XScrollView = UIScrollView
	public typealias XScrollViewDelegate = UIScrollViewDelegate
#endif

#if canImport(UIKit)
public typealias XContextMenuConfiguration = UIContextMenuConfiguration
#endif

#if canImport(AppKit)
// On macOS, there's no UIScrollViewDelegate equivalent, so we define an empty protocol
public protocol XScrollViewDelegate {}
#endif