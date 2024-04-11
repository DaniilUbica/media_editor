//
//  MediaSaver.swift
//  media_editor
//
//  Created by Daniil Ubica on 11.04.2024.
//

import Foundation
import Cocoa

enum ErrorType {
    case NoError
    case GetDataError
    case SaveMediaError
    case NoImageError
}

class ImageManager: ObservableObject {
    
    @Published var m_errorType: ErrorType = .NoError
    @Published var m_imagePath: String = ""
    private var m_image: NSImage? = nil
    
    var errorType: ErrorType {
        self.m_errorType
    }
    
    var imagePath: String {
        get {
            self.m_imagePath
        }
        set(newPath) {
            self.m_imagePath = newPath
            if self.m_errorType == .NoImageError {
                self.m_errorType = .NoError
            }
        }
    }
    
    var image: NSImage? {
        if let image = self.m_image {
            return image
        }
        else if !self.m_imagePath.isEmpty {
            self.m_image = NSImage(contentsOfFile: self.m_imagePath)
        }
        return self.m_image
    }
    
    func saveImage() {
        if let image = m_image {
            let panel = NSSavePanel()
            panel.allowedContentTypes = [.image]
            panel.canCreateDirectories = true
            panel.begin { response in
                if response == .OK {
                    if let url = panel.url {
                        self.saveImage(image, url: url)
                    }
                }
            }
        }
        else {
            if !self.m_imagePath.isEmpty {
                if let image = NSImage(contentsOfFile: self.m_imagePath) {
                    self.m_image = image
                }
                else {
                    self.m_errorType = .NoImageError
                    return
                }
                saveImage()
            }
            else {
                self.m_errorType = .NoImageError
                return
            }
        }
    }
    
    private func saveImage(_ image: NSImage, url: URL) {
        if let image = m_image {
            guard let imageData = image.tiffRepresentation,
                  let bitmapImage = NSBitmapImageRep(data: imageData),
                  let data = bitmapImage.representation(using: .png, properties: [:]) else {
                self.m_errorType = .GetDataError
                return
            }
            
            do {
                try data.write(to: url)
                self.m_errorType = .NoError
            } catch {
                self.m_errorType = .SaveMediaError
            }
        }
        else {
            if !self.m_imagePath.isEmpty {
                self.m_image = NSImage(contentsOfFile: self.m_imagePath)
                saveImage()
            }
            else {
                self.m_errorType = .NoImageError
                return
            }
        }
    }
}
