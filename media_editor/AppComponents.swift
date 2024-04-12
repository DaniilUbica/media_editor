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
    
    @EnvironmentObject private var imageManager: ImageManager
    @State private var openingFile = false
    
    var body: some View {
        Button("Open file") {
            openingFile.toggle()
        }
        .fileImporter(isPresented: $openingFile, allowedContentTypes: [.image, .video], allowsMultipleSelection: false) {
            result in
            
            do {
                let fileURL = try result.get()
                if let url = fileURL.first {
                    imageManager.loadImage(url.path())
                    imageManager.currFileExtension = url.pathExtension
                }
            }
            catch{
               print("error reading file \(error.localizedDescription)")
            }
        }
    }
}

struct FileSaver: View {
    
    @EnvironmentObject private var imageManager: ImageManager
    
    var body: some View {
        Button("Save file") {
            imageManager.saveImage()
        }
    }
}

struct ImagePreview: View {
    
    @EnvironmentObject private var imageManager: ImageManager
    
    var body: some View {
        VStack {
            imageManager.uiImage
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minWidth: 200.0, minHeight: 200.0)
        }
        .padding()
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
        .frame(minWidth: buttonMinimumWidth, idealWidth: buttonIdealWidth, minHeight: buttonMinimumHeight, idealHeight: buttonIdealHeight)
    }
}

struct ErrorPrinter: View {
    
    @EnvironmentObject private var imageManager: ImageManager
    
    var body: some View {
       
        Text(getErrorMessage())
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            .foregroundStyle(.red)
            .padding()
    }
    
    private func getErrorMessage() -> String {
        let errorString: String
        
        switch imageManager.errorType {
        case .NoError:
            errorString = ""
        case .GetDataError:
            errorString = "Error: can't get image data"
        case .SaveMediaError:
            errorString = "Error: can't save image"
        case .NoImageError:
            errorString = "Error: image is empty"
        }
        return errorString
    }
}
