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
            Text("Media Editor")
        }
    }
}

struct FilePicker: View {
    
    @EnvironmentObject private var imageManager: ImageManager
    @State private var openingFile = false
    @Binding var filePath: String
    @State var buttonText: String
    @State var rewriteImageManagerImage: Bool = true
    
    var body: some View {
        Button(buttonText) {
            openingFile.toggle()
        }
        .fileImporter(isPresented: $openingFile, allowedContentTypes: [.image, .video], allowsMultipleSelection: false) {
            result in
            
            do {
                let fileURL = try result.get()
                if let url = fileURL.first {
                    filePath = url.path()
                    if rewriteImageManagerImage {
                        DispatchQueue.main.async {
                            imageManager.loadImage(filePath)
                            imageManager.currFileExtension = url.pathExtension
                        }
                    }
                }
            }
            catch {
               print("error reading file \(error.localizedDescription)")
            }
        }
    }
}

struct FileSaver: View {
    
    @EnvironmentObject private var imageManager: ImageManager
    
    var body: some View {
        Button("Save file") {
            DispatchQueue.main.async {
                imageManager.saveImage()
            }
        }
    }
}

struct ImagePreview: View {
    
    @EnvironmentObject private var imageManager: ImageManager
    let mWidth: CGFloat
    let mHeight: CGFloat
    
    init(_ width: CGFloat, _ height: CGFloat) {
        mWidth = width
        mHeight = height
    }
    
    var body: some View {
        VStack {
            imageManager.uiImage
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minWidth: mWidth, maxWidth: mWidth, minHeight: mHeight, maxHeight: mHeight)
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
        .frame(minWidth: buttonMinimumWidth, idealWidth: buttonIdealWidth, minHeight: buttonMinimumHeight, idealHeight: buttonIdealHeight)
    }
}

struct ErrorPrinter: View {
    
    @EnvironmentObject private var imageManager: ImageManager
    
    var body: some View {
        Text(getErrorMessage())
            .font(.title)
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
        case .BackgroundRemoveError:
            errorString = "Error: can't remove background"
        case .BackgroundReplaceError:
            errorString = "Error: can't replace background"
        }
        return errorString
    }
}
