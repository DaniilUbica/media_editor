//
//  AppComponents.swift
//  media_editor
//
//  Created by Daniil Ubica on 09.04.2024.
//

import SwiftUI

struct HeaderAppInfo:View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Media Editor")
            
        }
    }
}

struct FilePicker: View {
    
    @Binding var pathToFile: String
    @State private var openFile = false
    
    var body: some View {
        Button("Open file") {
            openFile.toggle()
        }
        .fileImporter(isPresented: $openFile, allowedContentTypes: [.image, .video], allowsMultipleSelection: false) {
            result in
            
            do {
                let fileURL = try result.get()
                pathToFile = fileURL.first?.path() ?? "file not available"
            }
            catch{
               print("error reading file \(error.localizedDescription)")
            }
        }
    }
}

struct ImagePreview: View {
    
    @State var filePath: String
    
    var body: some View {
        VStack {
            imageFromPath()
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minWidth: 200.0, minHeight: 200.0)
        }
        .padding()
    }
    
    init(filePath: String) {
        self.filePath = filePath
    }
    
    private func imageFromPath() -> Image {
        if let nsImage = NSImage(contentsOfFile: filePath) {
            return Image(nsImage: nsImage)
        }
        else {
            return Image(systemName: "photo")
        }
    }
}

struct CustomButton: View {
    let text: String
    let action: () -> Void

    var body: some View {
        Button(text) {
            action()
        }
        .font(.title)
        .frame(minWidth: button_minimum_width, idealWidth: button_ideal_width, minHeight: button_minimum_height, idealHeight: button_ideal_height)
    }
}
