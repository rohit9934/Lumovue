//
//  WallpaperBlurView.swift
//  Lumovue
//
//  Created by Rohit on 09/01/25.
// WallpaperBlurView
import SwiftUI

struct WallpaperBlurView: View {
	var body: some View {
		GeometryReader { geometry in
			ZStack {
				Image("wallpaper")
					.resizable()
					.scaledToFill()
					.frame(width: geometry.size.width, height: geometry.size.height)
					.clipped()

				FrostedGlassOverlay()
					.frame(width: geometry.size.width, height: geometry.size.height)
			}
		}
	}
}

struct FrostedGlassOverlay: View {
	var body: some View {
		VisualEffectBlur(blurStyle: .hudWindow) // Corrected material
			.opacity(0.9) // Adjust opacity for subtlety
	}
}

struct VisualEffectBlur: View {
	var blurStyle: NSVisualEffectView.Material
	
	var body: some View {
		VisualEffectView(material: blurStyle)
			.edgesIgnoringSafeArea(.all)
	}
}

struct VisualEffectView: NSViewRepresentable {
	var material: NSVisualEffectView.Material
	
	func makeNSView(context: Context) -> NSVisualEffectView {
		let effectView = NSVisualEffectView()
		effectView.material = material
		effectView.blendingMode = .withinWindow
		effectView.state = .active
		return effectView
	}
	
	func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
		nsView.material = material
	}
}
