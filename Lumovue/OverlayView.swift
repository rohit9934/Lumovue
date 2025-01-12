//
//  OverlayView.swift
//  Lumovue
//
//  Created by Rohit on 09/01/25.
//

import SwiftUI
import AppKit

struct OverlayView: View {
	@State private var timeRemaining = 60
	@ObservedObject var manager: OverlayManager
	@State private var isVisible = false
	var body: some View {
		ZStack {
			// Translucent background with only the desktop wallpaper
			WallpaperBlurView()
				.edgesIgnoringSafeArea(.all)

			VStack {
						Text("Time Remaining: \(timeRemaining)")
							.font(.largeTitle)
							.foregroundColor(.white)
							.onAppear {
								startTimer()
							}
						Spacer()
							.frame(height: 20)
						Button(action: {
							manager.dismissOverlay()
						}) {
							Text("Dismiss")
								.padding()
								.background(Color.white)
								.foregroundColor(.black)
								.cornerRadius(10)
						}
					}.animation(.easeInOut(duration: 0.5), value: isVisible)
					.onAppear {
							isVisible = true
						}
		}
	}
	private func startTimer() {
		   Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
			   if timeRemaining > 0 {
				   timeRemaining -= 1
			   } else {
				   timer.invalidate()
				   manager.dismissOverlay() // Automatically dismiss overlay when time is up
			   }
		   }
	   }
}
