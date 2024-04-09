//
//  AppState.swift
//  media_editor
//
//  Created by Daniil Ubica on 09.04.2024.
//

import Foundation

enum Route {
    case Main
    case RemoveBackground
    case ImproveQuality
}

class AppState: ObservableObject {
    @Published var currRoute: Route = .Main
    
    var currentRoute: Route? {
        currRoute
    }
}
