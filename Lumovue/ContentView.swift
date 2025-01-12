//
//  ContentView.swift
//  Lumovue
//
//  Created by Rohit on 09/01/25.
//

import SwiftUI

struct ContentView: View {
	@StateObject private var overlayManager = OverlayManager()
	
	var body: some View {
		VStack {
			Button("Lock Screen for 10 Seconds") {
				overlayManager.showOverlay()
					
				
				// Auto-dismiss after 10 seconds
			}
		}
		.frame(width: 300, height: 100)
	}
}

#Preview {
    ContentView()
}
