//
//  TopMessageView.swift
//  Lumovue
//
//  Created by Rohit on 13/01/25.
//

import SwiftUI

struct TopMessageView: View {
	@State private var showMessage = false
	@State private var messageViewOffset: CGFloat = -60 // Start position outside the notch area
	
	var body: some View {
		VStack {
			Button("Show Message") {
				showMessage.toggle()
				animateMessage()
			}
			.padding()
			
			// This is the message view that will emerge from the notch area
			Text("Have a great day!")
				.font(.title)
				.foregroundColor(.white)
				.frame(width: 200, height: 50)
				.background(Color.blue)
				.cornerRadius(10)
				.offset(y: messageViewOffset)
				.animation(.easeInOut(duration: 0.5), value: messageViewOffset)
				.onAppear {
					if showMessage {
						messageViewOffset = 20 // Move down to a visible area
					}
				}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(Color.gray.opacity(0.1))
	}
	
	private func animateMessage() {
		// Animate the view from the notch
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
			// Slide the message down from the notch
			messageViewOffset = 20
			
			// After 5 seconds, slide it back up into the notch
			DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
				messageViewOffset = -60
			}
		}
	}
}
