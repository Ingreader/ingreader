// Playground - noun: a place where people can play

import UIKit
import CoreImage

var str = "Hello, playground"


//print( CIFilter.filterNamesInCategory(kCICategoryBuiltIn))
print( CIFilter.filterNames(inCategory:kCICategoryBuiltIn))


var sample = UIImage(named: "probka1x.jpg")

var context: CIContext = CIContext(options:nil);


//var coreImage = CIImage(image: sample)

//
//var data = NSData(contentsOfFile: "/Users/kamelury/workspace/ios/ingreader/ingreader/probka1x.png")
//var image = UIImage(data: data)
//var coreImage = CIImage(image: image)
//
var ciiiii = sample?.cgImage
var nic = CIImage.empty()

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


func imageByDrawing(size: CGSize, scale:CGFloat, closure: () -> ()) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size,false,scale)
    closure()
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result!
}

func prepareImage(source: UIImage, saturation: CGFloat = 1) -> UIImage {
    let size = source.size
//    var bounds = CGRect(x:0, y:0, width: size.width, height: size.height)
    return imageByDrawing(size:size, scale:source.scale) {
        source.draw(at:CGPoint())
    }
}

prepareImage(source:sample!)
prepareImage(source:sample!, saturation: 1.0/3.0)
prepareImage(source:sample!, saturation: 0)

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
