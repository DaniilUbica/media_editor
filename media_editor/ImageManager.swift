//
//  MediaSaver.swift
//  media_editor
//
//  Created by Daniil Ubica on 11.04.2024.
//

import Foundation
import Cocoa
import SwiftUI

enum ErrorType {
    case NoError
    case GetDataError
    case SaveMediaError
    case NoImageError
    case BackgroundReplaceError
    case BackgroundRemoveError
}

class ImageManager: ObservableObject {
    
    @Published var mErrorType: ErrorType = .NoError
    @Published var mCurrFileExtension: String = ""
    @Published var mProcessingNow: Bool = false
    private var mImage: NSImage? = nil
    private let mBackgroundReplacer: BackgroundReplacer = BackgroundReplacer()
     
    var errorType: ErrorType {
        mErrorType
    }
    
    var currFileExtension: String {
        get {
            mCurrFileExtension
        }
        set(newExtension) {
            mCurrFileExtension = newExtension
        }
    }
    
    var processingNow: Bool {
        mProcessingNow
    }
    
    var image: NSImage? {
        get {
            return mImage
        }
        set(newImage) {
            mImage = newImage
            if mImage != nil && mErrorType == .NoImageError {
                mErrorType = .NoError
            }
        }
    }
    
    var uiImage: Image {
        get {
            if let image = mImage {
                return Image(nsImage: image)
            }
            return Image(systemName: "photo")
        }
    }
    
    
    func saveImage() {
        if let image = mImage {
            let panel = NSSavePanel()
            panel.allowedContentTypes = [.image]
            panel.canCreateDirectories = true
            panel.isExtensionHidden = false
            panel.nameFieldStringValue = "Untitled.\(mCurrFileExtension)"
            panel.begin { response in
                if response == .OK {
                    if let url = panel.url {
                        self.saveImage(image, url)
                    }
                }
            }
        }
        else {
            mErrorType = .NoImageError
            return
        }
    }
        
    func loadImage(_ path: String) {
        mImage = NSImage(contentsOfFile: path)
        if mErrorType == .NoImageError {
            mErrorType = .NoError
        }
    }
    
    func removeBackground(_ onProcessEnd: @escaping () -> Void) {
        DispatchQueue.main.async {
            if let image = self.mImage {
                if let newImage = self.mBackgroundReplacer.removeBackground(image) {
                    let rep = NSCIImageRep(ciImage: newImage)
                    self.mImage = NSImage(size: rep.size)
                    self.mImage?.addRepresentation(rep)
                    onProcessEnd()
                }
                else {
                    self.mErrorType = .BackgroundRemoveError
                }
            }
            else {
                self.mErrorType = .NoImageError
            }
        }
    }
    
    func replaceBackground(_ newBackground: NSImage?, _ onProcessEnd: @escaping () -> Void) {
        DispatchQueue.main.async {
            if let image = self.mImage, let background = newBackground {
                if let newImage = self.mBackgroundReplacer.replaceBackground(image, background) {
                    let rep = NSCIImageRep(ciImage: newImage)
                    self.mImage = NSImage(size: rep.size)
                    self.mImage?.addRepresentation(rep)
                    onProcessEnd()
                }
                else {
                    self.mErrorType = .BackgroundReplaceError
                }
            }
            else {
                self.mErrorType = .NoImageError
            }
        }
    }
    
    func replaceBackground(_ newBackgroundPath: String, _ onProcessEnd: @escaping () -> Void) {
        if let newBackground = NSImage(contentsOfFile: newBackgroundPath) {
            if let _ = mImage {
                replaceBackground(newBackground, onProcessEnd)
            }
            else {
                mErrorType = .NoImageError
            }
        }
    }
    
    private func saveImage(_ image: NSImage, _ url: URL) {
        guard let imageData = image.tiffRepresentation,
              let bitmapImage = NSBitmapImageRep(data: imageData),
              let data = bitmapImage.representation(using: .png, properties: [:]) else {
            mErrorType = .GetDataError
            return
        }
        
        do {
            try data.write(to: url)
            mErrorType = .NoError
        } catch {
            mErrorType = .SaveMediaError
            return
        }
    }
}
