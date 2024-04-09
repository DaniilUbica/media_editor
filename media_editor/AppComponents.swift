//
//  AppComponents.swift
//  media_editor
//
//  Created by Daniil Ubica on 09.04.2024.
//

import SwiftUI

struct CustomButton: View {
    let text: String
    let action: () -> Void

    var body: some View {
        Button(text) {
            action()
        }
        .font(.title)
    }
}
