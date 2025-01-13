//
//  ContentView.swift
//  Lumovue
//
//  Created by Rohit on 09/01/25.
//

import SwiftUI

struct ContentView: View {
	@StateObject private var overlayManager = OverlayManager()
	private let notificationView = NotchNotificationView()
	var body: some View {
		VStack {
			Button("Lock Screen for 10 Seconds") {
				overlayManager.showOverlay()
					
				
				// Auto-dismiss after 10 seconds
			}
			Button("Show Notification") {
							notificationView.showNotification()
					}
		}
		.frame(width: 300, height: 100)
		.padding()
	}
}

#Preview {
    ContentView()
}
