//
//  OverlayView.swift
//  Lumovue
//
//  Created by Rohit on 09/01/25.
//

import SwiftUI
import AppKit

struct OverlayView: View {
	@ObservedObject var manager: OverlayManager
	@State private var isVisible = false
	var body: some View {
		ZStack {
			// Translucent background with only the desktop wallpaper
			WallpaperBlurView()
				.edgesIgnoringSafeArea(.all)

			VStack {
				Text("Screen Locked")
					.font(.largeTitle)
					.foregroundColor(.white)
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
}
