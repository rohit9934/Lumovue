//
//  ContentView.swift
//  Lumovue
//
//  Created by Rohit on 09/01/25.
//

import SwiftUI
import Foundation
struct ContentView: View {
	@StateObject private var overlayManager = OverlayManager()
	private var timerManager = TimerManager()
	private let notificationView = NotchNotificationView()
	var body: some View {
		VStack {
			Button("Lock Screen for 10 Seconds") {
				overlayManager.showOverlay()
					
				
				// Auto-dismiss after 10 seconds
			}
			HStack {
				Button("Show Notification") {
					notificationView.showNotification {
						overlayManager.showOverlay()
					}
				}

			}

		}
		.frame(width: 300, height: 100)
		.padding()
		.onAppear {
			timerManager.startTimer()
		}
	}

}

#Preview {
    ContentView()
}
