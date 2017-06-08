// Playground - noun: a place where people can play

import UIKit
import CoreImage


var str = "Hello, playground"

//print( CIFilter.filterNames(inCategory:kCICategoryBuiltIn))


var sample = UIImage(named: "probka1x.jpg")
var color_sample = UIImage(named: "probka2.jpeg")

var context: CIContext = CIContext(options:nil);


//var coreImage = CIImage(image: sample)

//
//var data = NSData(contentsOfFile: "/Users/kamelury/workspace/ios/ingreader/ingreader/probka1x.png")
//var image = UIImage(data: data)
//var coreImage = CIImage(image: image)
//
//var ciiiii = sample?.cgImage
//var nic = CIImage.empty()

//
//var fileNameAndPath = NSURL.fileURLWithPath("/Users/kamelury/workspace/ios/ingreader/ingreader/probka1x.png")
//var originalImage: CIImage = CIImage(contentsOfURL: fileNameAndPath)
//var params : NSDictionary = NSDictionary(object: kCIInputImageKey, forKey: originalImage)
//
//
//
//var filter = CIFilter(name: "CIMedianFilter", withInputParameters:params )
//var outputImage : CIImage = filter.outputImage;


//var cgimg: CGImageRef  = context.createCGImage(outputImage, fromRect: outputImage.extent())

// var newImage : UIImage? = UIImage(CIImage: originalImage)
//var newImage : UIImage? = UIImage(CGImage: cgimg)


//CGImageRelease(cgimg)


//CIImage *beginImage = [CIImage imageWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"probka1x" ofType:@"png"]]];
//CIImage *inputGradientImage = [CIImage imageWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"grad" ofType:@"png"]]];
//CIContext *context = [CIContext contextWithOptions:nil];
//CIFilter *filter = [CIFilter filterWithName:@"CIColorMap" keysAndValues:kCIInputImageKey, beginImage, @"inputGradientImage",inputGradientImage, nil];
//CIImage *outputImage = [filter outputImage];
//CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
//UIImage *newImage = [UIImage imageWithCGImage:cgimg];
//self.imageView.image = newImage;
//CGImageRelease(cgimg);

color_sample

func imageByDrawing(size: CGSize, scale:CGFloat, closure: () -> ()) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size,false,scale)
    closure()
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result!
}

func prepareImage(source: UIImage, saturation: CGFloat) -> UIImage {
    let size = source.size
//    var bounds = CGRect(x:0, y:0, width: size.width, height: size.height)
    return imageByDrawing(size:size, scale:source.scale) {
        source.draw(at:CGPoint())
    }
}

//prepareImage(source:color_sample!, saturation: 1)
//prepareImage(source:color_sample!, saturation: 1.0/3.0)
//prepareImage(source:color_sample!, saturation: 0)



/**
 //        A convenience method for using CoreImage filters to preprocess an image by
 //        1) setting the saturation to 0 to achieve grayscale,
 //        2) increasing the contrast by 10% to make black parts blacker, and
 //        3) reducing the exposure by 30% to reduce the amount of "light" in the image.
 **/





//let desaturated = color_sample?.imageDesaturated();
//let contrasted = desaturated?.contrast(percent: 10);
//let exposured = contrasted?.exposure(percent: -30);

//color_sample?.imageDesaturated()?.contrast(percent: 10)?.exposure(percent: -30);


//func sharpenImage (source: UIImage) -> UIImage?{
//
//
//
//
//    var newImage : UIImage? = UIImage(CIImage: originalImage)
//    return newImage!
//}
//CIMedianFilter
//CINoiseReduction
//CISharpenLuminance

//    var originalImage : CIImage? = sample.CIImage
//var bundle =   NSBundle.mainBundle()
//var path = bundle.pathForResource("probka1x", ofType:"png")
