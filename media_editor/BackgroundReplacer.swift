//
//  BackgroundRemover.swift
//  media_editor
//
//  Created by Daniil Ubica on 12.04.2024.
//

import Cocoa
import Vision

class BackgroundReplacer {
    
    func replaceBackground(_ image: NSImage, _ background: NSImage) -> CIImage? {
        let request = VNGenerateForegroundInstanceMaskRequest()
        
        guard let cgImage = getCGImageFromNSImage(image) else {
            print("Error getting CGImage")
            return nil
        }
        
        guard let cgBackground = getCGImageFromNSImage(background) else {
            print("Error getting CGImage")
            return nil
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        
        do {
            try requestHandler.perform([request])
            guard let result = request.results?.first
            else {
                print("Error getting mask")
                return nil
            }
            
            let mask = try result.generateScaledMaskForImage(forInstances: result.allInstances, from: requestHandler)

            
            let ciImage = CIImage(cgImage: cgImage)
            let ciBackground = CIImage(cgImage: cgBackground)
            let maskImage = CIImage(cvPixelBuffer: mask)
            
            let img = blendImages(ciImage, maskImage, ciBackground)
            return img
        }
        catch {
            print("Error processing person segmentation request")
            return nil
        }
    }
    
    func removeBackground(_ image: NSImage) -> CIImage? {
        if let background = NSImage(named: transparentBackground) {
            return replaceBackground(image, background)
        }
        return nil
    }
    
    private func blendImages(_ image: CIImage, _ mask: CIImage, _ background: CIImage) -> CIImage? {
        let scaleX = image.extent.size.width / mask.extent.width
        let scaleY = image.extent.size.height / mask.extent.height
        let scaledMask = mask.transformed(by: .init(scaleX: scaleX, y: scaleY))
        
        let backgroundScaleX = image.extent.size.width / background.extent.width
        let backgroundScaleY = image.extent.size.height / background.extent.height
        let backgroundScaled = background.transformed(by: __CGAffineTransformMake(backgroundScaleX, 0, 0, backgroundScaleY, 0, 0))
                
        let filter = CIFilter(name: "CIBlendWithMask")
        filter?.setValue(backgroundScaled, forKey: kCIInputBackgroundImageKey)
        filter?.setValue(image, forKey: kCIInputImageKey)
        filter?.setValue(scaledMask, forKey: kCIInputMaskImageKey)
        
        return filter!.outputImage
    }
    
    private func getCGImageFromNSImage(_ image: NSImage) -> CGImage? {
        var imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        let imageRef = image.cgImage(forProposedRect: &imageRect, context: nil, hints: nil)
        return imageRef
    }
}

