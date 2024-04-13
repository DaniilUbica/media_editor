//
//  ContentView.swift
//  media_editor
//
//  Created by Daniil Ubica on 09.04.2024.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var imageManager: ImageManager
    @State private var filePath: String = ""
    @State private var backgroundFilePath: String = ""
    
    var body: some View {
        VStack {
            if (appState.currentRoute != .Main) {
                CustomButton(text: "<-") {
                    appState.currentRoute = .Main
                }
                .padding(.top)
            }
            else {
                HeaderAppInfo()
                    .padding(.top)
                Text("Current file: \(filePath)")
                    .padding(.top)
                ImagePreview(mainPageImagePreviewWidth, mainPageImagePreviewHeight)
                    .padding(.top)
                HStack {
                    FilePicker(filePath: $filePath, buttonText: "Open image")
                        .padding()
                    FileSaver()
                        .padding()
                }
            }
            
            if let currRoute = appState.currentRoute {
                switch currRoute {
                case .RemoveBackground:
                    RemoveBackgroundView()
                case .ReplaceBackground:
                    ReplaceBackgroundView()
                case .ImproveQuality:
                    ImproveQualityView()
                case .Main:
                    MainView()
                }
            }
            
            ErrorPrinter()
                .padding(.bottom)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        .environmentObject(AppState())
        .environmentObject(ImageManager())
    }
}
