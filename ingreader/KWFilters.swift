//
//  KWFilters.swift
//  ingreader
//
//  Created by Kamila Wojciechowska on 05.07.2014.
//  Copyright (c) 2014 silk. All rights reserved.
//

import UIKit

class KWFilters: CIFilter {
    
    class func sharpenImage (image: UIImage) -> (output: UIImage)  {
        let context = UIGraphicsGetCurrentContext()
        // var context: CIContext = CIContext(options:nil);
        let ciContext = CIContext(options: nil)
        let coreImage = CIImage(image: image)
        
        let filter = CIFilter(name: "CISharpenLuminance")
        filter.setValue(0.9, forKey: kCIInputSharpnessKey)
        
        // we pass our image as input
        filter.setValue(coreImage, forKey: kCIInputImageKey)
        
        // we retrieve the processed image
        let filteredImageData = filter.valueForKey(kCIOutputImageKey) as CIImage
        // returns a Quartz image from the Core Image context
        let filteredImageRef = ciContext.createCGImage(filteredImageData, fromRect: filteredImageData.extent())
        // this is our final UIImage ready to be displayed
        let filteredImage = UIImage(CGImage: filteredImageRef);
        
        return filteredImage;
        
    }
    
    class func binarizeImage (image: UIImage) -> (output: UIImage)  {
        let context = UIGraphicsGetCurrentContext()
        // var context: CIContext = CIContext(options:nil);
        let ciContext = CIContext(options: nil)
        let coreImage = CIImage(image: image)
        
        let filter = CIFilter(name: "CIColorMonochrome")
        // filter.setValue(1.0, forKey: kCIInputIntensityKey)
        let white = CIColor(red: 255.0, green: 255.0, blue: 255.0)
        filter.setValue(white, forKey: kCIInputColorKey)
        
        
        // we pass our image as input
        filter.setValue(coreImage, forKey: kCIInputImageKey)
        
        // we retrieve the processed image
        let filteredImageData = filter.valueForKey(kCIOutputImageKey) as CIImage
        // returns a Quartz image from the Core Image context
        let filteredImageRef = ciContext.createCGImage(filteredImageData, fromRect: filteredImageData.extent())
        // this is our final UIImage ready to be displayed
        let filteredImage = UIImage(CGImage: filteredImageRef);
        
        return filteredImage;
        
    }

}
