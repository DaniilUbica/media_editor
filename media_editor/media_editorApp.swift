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
            .frame(minWidth: main_window_minimum_width, idealWidth: main_window_start_width, minHeight: main_window_minimum_height, idealHeight: main_window_start_height)
            .environmentObject(AppState())
        }
    }
}
