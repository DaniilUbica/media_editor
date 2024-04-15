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
            TestImageDragDrop()
        }
        .padding()
    }
}

struct RemoveBackgroundView: View {
    
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var imageManager: ImageManager
    @State private var showingRemoved: Bool = false
    @State private var processingNow: Bool = false
        
    var body: some View {
        if !showingRemoved {
            ImagePreview(imagePreviewWidth, imagePreviewHeight)
        }
        else {
            imageWithoutBackground()
        }
        
        CustomButton(text: "Remove background") {
            if imageManager.image != nil {
                processingNow = true
            }
            imageManager.removeBackground(onProcessEnded)
        }
        
        if processingNow {
            ProgressView("Removing...")
        }
    }
    
    private func imageWithoutBackground() -> ImagePreview {
        return ImagePreview(imagePreviewWidth, imagePreviewHeight)
    }
    
    private func onProcessEnded() {
        processingNow = false
        showingRemoved.toggle()
    }
}

struct ReplaceBackgroundView: View {
    
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var imageManager: ImageManager
    @State private var showingReplaced: Bool = false
    @State private var backgroundFilePath: String = ""
    @State private var processingNow: Bool = false
        
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
                    if imageManager.errorType == .NoError {
                        if imageManager.image != nil {
                            processingNow = true
                        }
                        let background = NSImage(contentsOfFile: backgroundFilePath)
                        imageManager.replaceBackground(background, onProcessEnded)
                    }
                }
                
                if processingNow {
                    ProgressView("Replacing...")
                }
            }
    }
    
    private func imageWithReplacedBackground() -> ImagePreview {
        return ImagePreview(imagePreviewWidth, imagePreviewHeight)
    }
    
    private func onProcessEnded() {
        processingNow = false
        showingReplaced.toggle()
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
