//
//  OverlayManager.swift
//  Lumovue
//
//  Created by Rohit on 09/01/25.
//

import AppKit
import SwiftUI

class OverlayManager: ObservableObject {
	var overlayWindows: [NSWindow] = []
	
	func showOverlay() {
		let screens = NSScreen.screens
		
		// Create an overlay window for each screen
		overlayWindows = screens.map { screen -> NSWindow in
			let overlayWindow = NSWindow(
				contentRect: screen.frame,
				styleMask: [.borderless],
				backing: .buffered,
				defer: false
			)
			overlayWindow.level = .mainMenu + 1  // Above all other windows
			overlayWindow.backgroundColor = NSColor.black
			overlayWindow.makeKeyAndOrderFront(nil)
			overlayWindow.isOpaque = true
			overlayWindow.ignoresMouseEvents = false
			overlayWindow.collectionBehavior = [.stationary, .ignoresCycle]
			
			// Set up the overlay view with a dismiss button
			let hostingView = NSHostingView(rootView: OverlayView(manager: self))
			overlayWindow.contentView = hostingView
			
			return overlayWindow
		}
	}
	
	func dismissOverlay() {
		overlayWindows.forEach { $0.orderOut(nil) }
		overlayWindows.removeAll()
	}
}
