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
                Text("Current file: \(filePath)")
                    .padding(.top)
                ImagePreview(mainPageImagePreviewWidth, mainPageImagePreviewHeight)
                HStack {
                    FilePicker(filePath: $filePath)
                }
                .padding()
                
                FileSaver()
                .padding()
            }
            
            if let currRoute = appState.currentRoute {
                switch currRoute {
                case .RemoveBackground:
                    RemoveBackgroundView()
                case .ImproveQuality:
                    ImproveQualityView()
                case .Main:
                    MainView()
                }
            }
            
            ErrorPrinter()
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
