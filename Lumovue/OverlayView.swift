//
//  OverlayView.swift
//  Lumovue
//
//  Created by Rohit on 09/01/25.
//

import SwiftUI
import AppKit

struct OverlayView: View {
	@State private var timeRemaining = 35
	@ObservedObject var manager: OverlayManager
	@State private var timer: Timer?
	@State private var isVisible = false
	var formattedTime: String {
		let minutes = timeRemaining / 60
		let seconds = timeRemaining % 60
		return String(format: "%02d:%02d", minutes, seconds)
	}
	var body: some View {
		ZStack {
			WallpaperBlurView()
				.edgesIgnoringSafeArea(.all)
			VStack {
				Text("What a Beautiful Day")
					.font(.largeTitle)
				Text("Time Remaining: \(formattedTime)")
					.font(.largeTitle)
					.foregroundColor(.white)
					.onAppear {
						startTimer()
					}
				Button(action: {
					// Action for dismissing
					manager.dismissOverlay()
				}) {
					Text("Dismiss")
						.font(.system(size: 12)) // Adjust font size to fit the frame
						.foregroundColor(.black) // Black text
						.frame(width: 75, height: 40) // Set exact width and height
						.background(Color.white) // White background
						.cornerRadius(10) // Rounded corners with radius 10
						.shadow(radius: 5) // Optional: Add shadow for a lifted effect
				}
				.buttonStyle(PlainButtonStyle()) // Remove any default button padding
			}
			.padding()
		}.animation(.easeInOut(duration: 0.5), value: isVisible)
			.onAppear {
				isVisible = true
			}
	}
	
	
	func startTimer() {
		timer?.invalidate() // Invalidate any existing timer
		timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
			if timeRemaining > 0 {
				timeRemaining -= 1
			} else {
				timer?.invalidate() // Stop the timer when it reaches 0
			}
		}
	}
}

