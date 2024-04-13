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
            CustomButton(text: "Replace Background") {
                appState.currentRoute = .ReplaceBackground
            }
//            CustomButton(text: "Improve Quality") {
//                appState.currentRoute = .ImproveQuality
//            }
        }
        .padding()
    }
}

struct RemoveBackgroundView: View {
    
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var imageManager: ImageManager
    @State private var showingRemoved: Bool = false
        
    var body: some View {
        
            if !showingRemoved {
                ImagePreview(imagePreviewWidth, imagePreviewHeight)
            }
            else {
                imageWithoutBackground()
            }
            
            CustomButton(text: "Remove background") {
                showingRemoved.toggle()
            }
    }
    
    private func imageWithoutBackground() -> ImagePreview {
        DispatchQueue.main.async {
            imageManager.removeBackground()
        }
        return ImagePreview(imagePreviewWidth, imagePreviewHeight)
    }
}

struct ReplaceBackgroundView: View {
    
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var imageManager: ImageManager
    @State private var showingReplaced: Bool = false
    @State private var backgroundFilePath: String = ""
        
    var body: some View {
        
            if !showingReplaced {
                ImagePreview(imagePreviewWidth, imagePreviewHeight)
            }
            else {
                imageWithReplacedBackground()
            }
        
            VStack {
                FilePicker(filePath: $backgroundFilePath, buttonText: "Open background", rewriteImageManagerImage: false)
                
                CustomButton(text: "Replace background") {
                    showingReplaced.toggle()
                }
            }
    }
    
    private func imageWithReplacedBackground() -> ImagePreview {
        DispatchQueue.main.async {
            if let background = NSImage(contentsOfFile: backgroundFilePath) {
                imageManager.replaceBackground(background)
            }
        }
        return ImagePreview(imagePreviewWidth, imagePreviewHeight)
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
