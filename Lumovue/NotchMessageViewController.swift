//
//  NotchMessageViewController.swift
//  Lumovue
//
//  Created by Rohit on 13/01/25.
//
import Cocoa

class NotchNotificationController: NSObject {
	private var window: NSWindow!
	private var timer: Timer?
	private var notchWidth: CGFloat = 300
	private var notchHeight: CGFloat = 0
	private var isVisible = false
	private var backgroundView: NSView!
	private var countdownTimer: Timer?
	private var remainingTime = 6 // Start with 5 seconds

	override init() {
		super.init()
		setupWindow()
	}

	private func setupWindow() {
		let screenFrame = NSScreen.main?.frame ?? .zero
		let viewWidth: CGFloat = 300
		let viewHeight: CGFloat = 50

		// Position: Attach the top of the view to the top of the screen (the notch area)
		let initialY = screenFrame.maxY - 100// Positioning the top of the view at the top of the screen
		let initialFrame = CGRect(
			x: (screenFrame.width - viewWidth) / 2,
			y: initialY, // Top of the screen
			width: viewWidth,
			height: viewHeight
		)

		// Create NSWindow
		window = NSWindow(
			contentRect: initialFrame,
			styleMask: .borderless,
			backing: .buffered,
			defer: false
		)
		window.level = .statusBar // Ensures it appears above the menu bar
		window.collectionBehavior = [.canJoinAllSpaces, .stationary]
		window.isReleasedWhenClosed = false
		window.isOpaque = false
		window.backgroundColor = .clear
		window.level = .floating
		
		// Add VisualEffectView
		backgroundView = NSView(frame: initialFrame)
		backgroundView.wantsLayer = true
		backgroundView.layer?.backgroundColor = NSColor.black.cgColor
		//backgroundView.layer?.cornerRadius = 15
		backgroundView.layer?.masksToBounds = true
		applyCustomCorners(to: backgroundView)
		// Add Content
		
		//createUI()
		// Set content view
		window.contentView = backgroundView
	}

	func createUI() {
		//backgroundView.removeFromSuperview()
		backgroundView.subviews.forEach { $0.removeFromSuperview() }
		let stackView = NSStackView()
		stackView.orientation = .vertical
		stackView.alignment = .centerX
		stackView.spacing = 8

		// Title Label
		let titleLabel = NSTextField(labelWithString: "The Break will start in \(remainingTime) seconds")
		titleLabel.font = NSFont.systemFont(ofSize: 16)
		   titleLabel.textColor = .white
		   titleLabel.alignment = .center

		   // Add to Stack
		   stackView.addArrangedSubview(titleLabel)

		// Add Stack to VisualEffectView
		backgroundView.addSubview(stackView)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			stackView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
			stackView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor)
		])
		countdownTimer?.invalidate() // Ensure no other timer is running
			countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
				guard let self = self else { return }
				self.remainingTime -= 1
				titleLabel.stringValue = "The Break will start in \(self.remainingTime) seconds"
				
				if self.remainingTime <= 1 {
					timer.invalidate()
					//titleLabel.stringValue = "Break Started!"
					// Optionally, perform further actions when the timer reaches zero
				}
			}
	}
	func showNotification(timerComplete: @escaping () -> Void) {
		guard let screenFrame = NSScreen.main?.frame else { return }
		remainingTime = 10
		createUI()
		// Calculate final Y position (just below the notch area)
		let finalY = screenFrame.maxY - 10 // Adjust as necessary for positioning below the notch
		let initialY = screenFrame.maxY + 10 // Position initially above the screen

		// Set the window's initial position (above the screen) and invisible
		window.setFrameOrigin(CGPoint(x: window.frame.origin.x, y: initialY))
		window.alphaValue = 0.0 // Make the window initially invisible
		window.orderFrontRegardless() // Bring the window to the front

		// Ensure that the window has a layer (needed for opacity animation)
		window.contentView?.wantsLayer = true
		
		// Start animation group with spring effect
		NSAnimationContext.runAnimationGroup({ context in
			context.duration = 0.6
			context.timingFunction = CAMediaTimingFunction(name: .easeIn) // Starts fast, ends slowly, like a "drag"

			// Animate window's Y position to final position (slide down effect)
			window.setFrameOrigin(CGPoint(x: window.frame.origin.x, y: finalY))

			// Animate the alpha value to make it fade in
			window.animator().alphaValue = 1.0
		}, completionHandler: {
			// Optionally, trigger the timer to auto-hide the notification after 5 seconds
			self.timer?.invalidate()
			self.timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(self.remainingTime - 1), repeats: false) { [weak self] _ in
				
				timerComplete()
				self?.hideNotification()
			}
		})
	}

	private func hideNotification() {
		guard let screenFrame = NSScreen.main?.frame else { return }

		// Calculate hidden Y position (at the top of the screen again)
		let hiddenY = screenFrame.maxY // Top of the screen

		// Animate Slide Up
		NSAnimationContext.runAnimationGroup { context in
			context.duration = 0.5
			context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
			window.setFrameOrigin(CGPoint(x: window.frame.origin.x, y: hiddenY - 50))
			window.alphaValue = 0.0
		}

		// Hide the window after animation
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			self.window.orderOut(nil)
		}
	}
	
}
// MARK: - NSViewControllerRepresentable
import SwiftUI
struct NotchNotificationView: NSViewControllerRepresentable {
	class Coordinator: NSObject {
		var controller: NotchNotificationController?
		
		init(controller: NotchNotificationController) {
			self.controller = controller
		}

		func showNotification(completion: @escaping ()-> ()) {
			controller?.showNotification {
				completion()
			}
		}
	}

	private let controller = NotchNotificationController()

	func makeCoordinator() -> Coordinator {
		return Coordinator(controller: controller)
	}

	func makeNSViewController(context: Context) -> NSViewController {
		// Return a simple NSViewController as the container for the notification
		return NSViewController()
	}

	func updateNSViewController(_ nsViewController: NSViewController, context: Context) {
		// Nothing to update
	}
	
	// Use this to trigger showNotification() from the SwiftUI view
	func showNotification(completion: @escaping()-> ()) {
		makeCoordinator().showNotification {
			completion()
		}
	}
}

extension NotchNotificationController {
	func applyCustomCorners(to view: NSView) {
		let width = view.bounds.width
		let height = view.bounds.height
		let radius: CGFloat = 15 // Adjust the radius for the corners

		// Create a mutable path
		let path = CGMutablePath()

		// Start at top-left corner
		path.move(to: CGPoint(x: 0, y: height)) // Start below the top-left convex corner
		path.addArc(
			center: CGPoint(x: radius, y: height),
			radius: radius,
			startAngle: 0,
			endAngle: .pi,
			clockwise: true
		)

		// Top-right convex corner
		path.addLine(to: CGPoint(x: width + radius, y: height)) // Horizontal line to top-right arc start
		path.addArc(
			center: CGPoint(x: width + radius, y: height),
			radius: radius,
			startAngle: .pi,
			endAngle: .pi,
			clockwise: false
		)

		// Bottom-right concave corner
		path.addLine(to: CGPoint(x: width, y: radius))
		path.addArc(
			center: CGPoint(x: width - radius, y: radius),
			radius: radius,
			startAngle:  0,
			endAngle: 1.5 * .pi,
			clockwise: true
		)

		// Bottom-left concave corner
		path.addLine(to: CGPoint(x: radius + width, y: 0)) // Horizontal line to bottom-left arc start
		path.addArc(
			center: CGPoint(x: radius, y: radius),
			radius: radius,
			startAngle: 1.5 * .pi,
			endAngle: .pi,
			clockwise: true
		)

		path.closeSubpath()

		// Apply the path as a mask
		let shapeLayer = CAShapeLayer()
		shapeLayer.path = path
		view.wantsLayer = true
		view.layer?.mask = shapeLayer
	}
}
