//
//  AppPages.swift
//  media_editor
//
//  Created by Daniil Ubica on 09.04.2024.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        VStack {
            CustomButton(text: "Remove Background") {
                appState.currentRoute = .RemoveBackground
            }
            CustomButton(text: "Improve Quality") {
                appState.currentRoute = .ImproveQuality
            }
        }
        .padding()
    }
}

struct RemoveBackgroundView: View {
    
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var imageManager: ImageManager
        
    var body: some View {
        VStack {
            imageWithoutBackground()
        }
        .padding()
    }
    
    private func imageWithoutBackground() -> ImagePreview{
        imageManager.removeBackground()
        return ImagePreview()
    }
}

struct ImproveQualityView: View {    
    
    @EnvironmentObject private var appState: AppState

    var body: some View {
        VStack {
            Text("Improve Quality View")
        }
        .padding()
    }
}
