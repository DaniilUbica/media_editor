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
    
    @Published var m_errorType: ErrorType      = .NoError
    @Published var m_imagePath: String         = ""
    @Published var m_currFileExtension: String = ""
    private var m_image: NSImage?              = nil
     
    var errorType: ErrorType {
        m_errorType
    }
    
    var imagePath: String {
        get {
            m_imagePath
        }
        set(newPath) {
            if m_errorType == .NoImageError && m_imagePath != newPath {
                m_errorType = .NoError
            }
            
            m_imagePath = newPath
            m_currFileExtension = URL(fileURLWithPath: m_imagePath).pathExtension
        }
    }
    
    var currFileFormat: String {
        get {
            m_currFileExtension
        }
        set(newExtension) {
            m_currFileExtension = newExtension
        }
    }
    
    var image: NSImage? {
        loadImage()
        return m_image
    }
    
    
    func saveImage() {
        if let image = m_image {
            let panel = NSSavePanel()
            panel.allowedContentTypes = [.image]
            panel.canCreateDirectories = true
            panel.isExtensionHidden = false
            panel.nameFieldStringValue = "Untitled.\(m_currFileExtension)"
            panel.begin { response in
                if response == .OK {
                    if let url = panel.url {
                        self.saveImage(image, url: url)
                    }
                }
            }
        }
        else {
            if !m_imagePath.isEmpty {
                if let image = NSImage(contentsOfFile: m_imagePath) {
                    m_image = image
                }
                else {
                    m_errorType = .NoImageError
                    return
                }
                saveImage()
            }
            else {
                m_errorType = .NoImageError
                return
            }
        }
    }
    
    private func loadImage() {
        if !m_imagePath.isEmpty {
            m_image = NSImage(contentsOfFile: m_imagePath)
        }
    }
    
    private func saveImage(_ image: NSImage, url: URL) {
        guard let imageData = image.tiffRepresentation,
              let bitmapImage = NSBitmapImageRep(data: imageData),
              let data = bitmapImage.representation(using: .png, properties: [:]) else {
            m_errorType = .GetDataError
            return
        }
        
        do {
            try data.write(to: url)
            m_errorType = .NoError
        } catch {
            m_errorType = .SaveMediaError
            return
        }
    }
}
