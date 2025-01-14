//
//  TimerManager.swift
//  Lumovue
//
//  Created by Rohit on 14/01/25.
//

import Foundation

class TimerManager {
	var overlayManager = OverlayManager()
	private let notificationView = NotchNotificationView()
	private var timer: Timer?
	private var startTime: Date?
	private var timeTillBreak: Int = 60 * 10
	deinit {
		timer?.invalidate()
	}
	
	func startTimer() {
		startTime = Date()
		timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
			self?.checkElapsedTime()
		}
	}
	
	private func checkElapsedTime() {
		guard let startTime = startTime else { return }
		let elapsedTime = Date().timeIntervalSince(startTime)
		if elapsedTime >= TimeInterval(timeTillBreak - 5) { // 10 minutes in seconds
			notificationView.showNotification {
				self.overlayManager.showOverlay()
			}
			timer?.invalidate() // Stop the timer once 10 minutes are up
		}
	}
}
