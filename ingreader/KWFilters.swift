//
//  KWFilters.swift
//  ingreader
//
//  Created by Kamila Wojciechowska on 05.07.2014.
//  Copyright (c) 2014 silk. All rights reserved.
//

import UIKit

class KWFilters: CIFilter {
    
    class func sharpenImage(_ image: UIImage) -> (UIImage)  {
        _ = UIGraphicsGetCurrentContext()
        let ciContext = CIContext(options: nil)
        let coreImage = CIImage(image: image)
        
        let filter = CIFilter(name: "CISharpenLuminance")
        filter!.setValue(0.9, forKey: kCIInputSharpnessKey)
        
        // we pass our image as input
        filter!.setValue(coreImage, forKey: kCIInputImageKey)
        
        // we retrieve the processed image
        let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
        // returns a Quartz image from the Core Image context
        let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
        // this is our final UIImage ready to be displayed
        let filteredImage = UIImage(cgImage: filteredImageRef!);
        return filteredImage;

    }
    
    class func binarizeImage(_ image: UIImage) -> (UIImage)  {
        _ = UIGraphicsGetCurrentContext()
        let ciContext = CIContext(options: nil)
        let coreImage = CIImage(image: image)
        
        let filter = CIFilter(name: "CIColorMonochrome")
        let white = CIColor(red: 255.0, green: 255.0, blue: 255.0)
        filter!.setValue(white, forKey: kCIInputColorKey)
        
        
        
        filter!.setValue(coreImage, forKey: kCIInputImageKey)
        
        let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
        let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
        let filteredImage = UIImage(cgImage: filteredImageRef!);
        return filteredImage;
        
    }
    
    class func customBinarizeImage(_ image: UIImage) -> (UIImage)  {
        _ = UIGraphicsGetCurrentContext()
        let ciContext = CIContext(options: nil)
        let coreImage = CIImage(image: image)
        
        let filter = KWBinarizeFilter()
        filter.inputImage = coreImage

        if let filteredImageData = filter.outputImage {
            let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
            let filteredImage = UIImage(cgImage: filteredImageRef!);
            return filteredImage;
        }
        return UIImage()
    }

}
