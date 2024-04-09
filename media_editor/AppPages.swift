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
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Media Editor")
            CustomButton(text: "Remove Background") {
                appState.currRoute = .RemoveBackground
            }
            CustomButton(text: "Improve Quality") {
                appState.currRoute = .ImproveQuality
            }
        }
        .padding()
    }
}

struct RemoveBackgroundView: View {
    
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        VStack {
            Text("Remove Background View")
            CustomButton(text: "To main page") {
                appState.currRoute = .Main
            }
        }
        .padding()
    }
}

struct ImproveQualityView: View {    
    
    @EnvironmentObject private var appState: AppState

    var body: some View {
        VStack {
            Text("Improve Quality View")
            CustomButton(text: "To main page") {
                appState.currRoute = .Main
            }
        }
        .padding()
    }
}
