//
//  media_editorApp.swift
//  media_editor
//
//  Created by Daniil Ubica on 09.04.2024.
//

import SwiftUI

@main
struct media_editorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
            .frame(minWidth: mainWindowMinimumWidth, idealWidth: mainWindowIdealWidth, minHeight: mainWindowMinimumHeight, idealHeight: mainWindowIdealHeight)
            .environmentObject(AppState())
            .environmentObject(ImageManager())
        }
    }
}
