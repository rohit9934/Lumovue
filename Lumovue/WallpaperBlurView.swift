//
//  WallpaperBlurView.swift
//  Lumovue
//
//  Created by Rohit on 09/01/25.
//
import SwiftUI
import Foundation
struct WallpaperBlurView: View {
	var body: some View {
		GeometryReader { geometry in
				Image("Beautiful_London")
					.resizable()
					.scaledToFill()
					.frame(width: geometry.size.width, height: geometry.size.height)
					.blur(radius: 20)  // Adjust blur radius as needed
			}
		}
	}
 
