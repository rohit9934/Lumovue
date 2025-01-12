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

		overlayWindows = screens.map { screen -> NSWindow in
			let initialSize = NSSize(width: screen.frame.width * 0.8, height: screen.frame.height * 0.8) // Small size to start
			
			let overlayWindow = NSWindow(
				contentRect: NSRect(x: screen.frame.origin.x + (screen.frame.width - initialSize.width) / 2,
									y: screen.frame.origin.y + (screen.frame.height - initialSize.height) / 2,
									width: initialSize.width,
									height: initialSize.height),
				styleMask: [.borderless],
				backing: .buffered,
				defer: false
			)
			overlayWindow.level = .mainMenu + 1
			overlayWindow.backgroundColor = NSColor.black.withAlphaComponent(0)
			overlayWindow.makeKeyAndOrderFront(nil)
			overlayWindow.isOpaque = false
			overlayWindow.ignoresMouseEvents = false
			overlayWindow.collectionBehavior = [.stationary, .ignoresCycle]
			
			let hostingView = NSHostingView(rootView: OverlayView(manager: self))
			overlayWindow.contentView = hostingView
			
			// Apply alpha animation
			if let contentView = overlayWindow.contentView {
				contentView.alphaValue = 0.0
				NSAnimationContext.runAnimationGroup { context in
					context.duration = 0.5
					context.allowsImplicitAnimation = true
					contentView.animator().alphaValue = 1.0
				}
			}

			// Animate scaling and opacity of the window
			NSAnimationContext.runAnimationGroup { context in
				context.duration = 0.5
				context.allowsImplicitAnimation = true
				overlayWindow.animator().setFrame(screen.frame, display: true)
				overlayWindow.animator().backgroundColor = NSColor.clear.withAlphaComponent(1)
			}

			return overlayWindow
		}
	}
	
	func dismissOverlay() {
		overlayWindows.forEach { overlayWindow in
			// Apply alpha animation for content view
			if let contentView = overlayWindow.contentView {
				NSAnimationContext.runAnimationGroup { context in
					context.duration = 0.5
					context.allowsImplicitAnimation = true
					contentView.animator().alphaValue = 0.0 // Fade out content
				}
			}

			// Animate background opacity and shrink window (scaled effect)
			NSAnimationContext.runAnimationGroup { context in
				context.duration = 0.5
				context.allowsImplicitAnimation = true
				overlayWindow.animator().backgroundColor = NSColor.clear.withAlphaComponent(0) // Fade background out
				
				// Reduce window size instead of setting frame to 0x0, so it shrinks smoothly
				let smallSize = NSSize(width: overlayWindow.frame.width * 0.8, height: overlayWindow.frame.height * 0.8)
				let smallFrame = NSRect(x: overlayWindow.frame.origin.x + (overlayWindow.frame.width - smallSize.width) / 2,
										y: overlayWindow.frame.origin.y + (overlayWindow.frame.height - smallSize.height) / 2,
										width: smallSize.width, height: smallSize.height)
				overlayWindow.animator().setFrame(smallFrame, display: true)
			}

			// After the animation ends, remove the window
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				overlayWindow.orderOut(nil) // Close the window after animation
			}
		}
		overlayWindows.removeAll() // Clear the overlay windows array
	}
}
