//
//  UIImage+Filters.swift
//  ingreader
//
//  Created by Kamila Wojciechowska on 6/8/17.
//  Copyright © 2017 silk. All rights reserved.
//

import Foundation

extension UIImage {
    
    func imageDesaturated() -> UIImage? {
        
        let context = CIContext.init(options: nil);
        let ciimage = CIImage.init(cgImage: self.cgImage!);
        let filter = CIFilter(name: "CIColorControls");
        
        filter!.setValue(ciimage, forKey: kCIInputImageKey);
        filter!.setValue(0, forKey: kCIInputSaturationKey);
        
        if let result = filter!.value(forKey: kCIOutputImageKey) {
            
            let ci_result: CIImage = result as! CIImage;
            let cgImage = context.createCGImage(ci_result, from: ci_result.extent);
            let image = UIImage.init(cgImage: cgImage!);
            return image;
        }
        
        return nil;
    }
    
    func contrast(percent: CGFloat) -> UIImage? {
        let context = CIContext.init(options: nil);
        let ciimage = CIImage.init(cgImage: self.cgImage!);
        let filter = CIFilter(name: "CIColorControls");
        
        filter!.setValue(ciimage, forKey: kCIInputImageKey);
        let value = 1 + percent/100;
        filter!.setValue(value, forKey: kCIInputContrastKey);
        
        if let result = filter!.value(forKey: kCIOutputImageKey) {
            
            let ci_result: CIImage = result as! CIImage;
            let cgImage = context.createCGImage(ci_result, from: ci_result.extent);
            let image = UIImage.init(cgImage: cgImage!);
            return image;
        }
        
        return nil;
        
    }
    
    func exposure(percent: CGFloat) -> UIImage? {
        
        let context = CIContext.init(options: nil);
        let ciimage = CIImage.init(cgImage: self.cgImage!);
        let filter = CIFilter(name: "CIExposureAdjust");
        
        filter!.setValue(ciimage, forKey: kCIInputImageKey);
        let value = 1 + percent/100;
        filter!.setValue(value, forKey: kCIInputEVKey);
        
        if let result = filter!.value(forKey: kCIOutputImageKey) {
            
            let ci_result: CIImage = result as! CIImage;
            let cgImage = context.createCGImage(ci_result, from: ci_result.extent);
            let image = UIImage.init(cgImage: cgImage!);
            return image;
        }
        
        return nil;
        
    }

/**
//    Steps adopted from a depracated method in UIImage+G8Filers.h
//    - (UIImage *)g8_blackAndWhite __attribute__((deprecated("This method is no longer supported as a part of Tesseract-OCR-iOS")));
//        A convenience method for using CoreImage filters to preprocess an image by
//        1) setting the saturation to 0 to achieve grayscale,
//        2) increasing the contrast by 10% to make black parts blacker, and
//        3) reducing the exposure by 30% to reduce the amount of "light" in the image.
**/
    
    func blackwhite() -> UIImage?{
        return self.imageDesaturated()?.contrast(percent: 10)?.exposure(percent: -30);
    }
}

