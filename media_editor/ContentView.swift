//
//  ContentView.swift
//  media_editor
//
//  Created by Daniil Ubica on 09.04.2024.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        .environmentObject(AppState())
    }
}
