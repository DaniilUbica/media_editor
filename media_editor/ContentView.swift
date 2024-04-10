//
//  ContentView.swift
//  media_editor
//
//  Created by Daniil Ubica on 09.04.2024.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var appState: AppState
    
    @State private var filePath: String = ""
    
    var body: some View {
        VStack {
            if (appState.currentRoute != .Main) {
                CustomButton(text: "<-") {
                    appState.currentRoute = .Main
                }
            }
            else {
                HeaderAppInfo()
                FilePicker(pathToFile: $filePath)
            }
            
            Text("Current loaded file path: \(filePath)")
            
            if let currRoute = appState.currentRoute {
                switch currRoute {
                case .RemoveBackground:
                    RemoveBackgroundView(filePath: filePath)
                case .ImproveQuality:
                    ImproveQualityView()
                case .Main:
                    MainView()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        .environmentObject(AppState())
    }
}
