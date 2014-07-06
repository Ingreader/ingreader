//
//  KWBinarizeFilter.m
//  ingreader
//
//  Created by Kamila Wojciechowska on 05.07.2014.
//  Copyright (c) 2014 silk. All rights reserved.
//

#import "KWBinarizeFilter.h"
#import <CoreImage/CoreImage.h>

@interface  KWBinarizeFilter()
{
    CIImage   *inputImage;
    NSNumber  *inputThreshold;
}

@end


@implementation KWBinarizeFilter
@synthesize inputImage;
@synthesize inputThreshold;

-(CIKernel *)myKernel {
    static CIColorKernel *kernel = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        kernel = [CIColorKernel kernelWithString:@"kernel vec4 thresholdKernel(sampler image, float inputThreshold)\n"
                  "{\n"
                  "  float pass = 1.0;\n"
                  "  float fail = 0.0;\n"
                  "  const vec4	vec_Y = vec4( 0.299, 0.587, 0.114, 0.0 );\n"
                  "  vec4		src = unpremultiply( sample(image, samplerCoord(image)) );\n"
                  "  float		Y = dot( src, vec_Y );\n"
                  "  src.rgb = vec3( compare( Y - inputThreshold, fail, pass));\n"
                  "  return premultiply(src);\n"
                  "}"]; });
    return kernel;
}

-(CIImage *)outputImage {
    CGRect dod = self.inputImage.extent;
    CIImage * image = [[self myKernel] applyWithExtent: dod
                                roiCallback: Nil
                                  arguments: @[self.inputImage, @0.3f] ];
    return image;
}
//
//
//+ (void)registerFilter
//{
//    NSDictionary *attributes = @{
//                                 kCIAttributeFilterCategories: @[
//                                         kCICategoryVideo,
//                                         kCICategoryStillImage,
//                                         kCICategoryCompositeOperation,
//                                         kCICategoryInterlaced,
//                                         kCICategoryNonSquarePixels
//                                         ],
//                                 kCIAttributeFilterDisplayName: @"Black & White Threshold",
//                                 
//                                 };
//    
//    [CIFilter registerFilterName:@"BlackAndWhiteThreshold"
//                     constructor:(id <CIFilterConstructor>)self
//                 classAttributes:attributes];
//}
//
//
//+ (CIFilter *)filterWithName:(NSString *)aName
//{
//    CIFilter  *filter;
//    filter = [[self alloc] init];
//    
//    return filter;
//}
//
//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        NSString *kernelText = @"kernel vec4 thresholdKernel(sampler image, float inputThreshold)\n"
//        "{\n"
//        "  float pass = 1.0;\n"
//        "  float fail = 0.0;\n"
//        "  const vec4	vec_Y = vec4( 0.299, 0.587, 0.114, 0.0 );\n"
//        "  vec4		src = unpremultiply( sample(image, samplerCoord(image)) );\n"
//        "  float		Y = dot( src, vec_Y );\n"
//        "  src.rgb = vec3( compare( Y - inputThreshold, fail, pass));\n"
//        "  return premultiply(src);\n"
//        "}";
//        
//        _kernel = [[CIKernel kernelsWithString:kernelText] objectAtIndex:0];
//    }
//    
//    return self;
//}
//
- (NSArray *)inputKeys {
    return @[@"inputImage",@"inputThreshold"];
}

- (NSArray *)outputKeys {
    return @[@"outputImage"];
}

- (void)setDefaults; {
   // inputThreshold =

}
- (NSDictionary *)customAttributes
{
    NSDictionary *thresholDictionary = @{
                                         kCIAttributeType: kCIAttributeTypeScalar,
                                         kCIAttributeMin: @0.0f,
                                         kCIAttributeMax: @1.0f,
                                         kCIAttributeIdentity : @0.00,
                                         kCIAttributeDefault: @0.5f,
                                         };
    
    return @{
             @"inputThreshold": thresholDictionary,
             // This is needed because the filter is registered under a different name than the class.
             kCIAttributeFilterName : @"BlackAndWhiteThreshold"
             };
}
//
//- (CIImage *)outputImage {
//    if (inputImage == nil) {
//        return nil;
//    }
//    
//    CISampler *sampler;
//    
//    sampler = [CISampler samplerWithImage:inputImage];
//    
//    NSArray * outputExtent = [NSArray arrayWithObjects:
//                              [NSNumber numberWithInt:[inputImage extent].origin.x],
//                              [NSNumber numberWithInt:[inputImage extent].origin.y],
//                              [NSNumber numberWithFloat:[inputImage extent].size.width],
//                              [NSNumber numberWithFloat:[inputImage extent].size.height],nil];
//    
//    
//    CIImage *outputImage =  [self apply: _kernel,
//                             sampler,
//                             inputThreshold,
//                             kCIApplyOptionExtent, outputExtent,
//                             kCIApplyOptionDefinition, [sampler definition],
//                             nil];
//    
//    
//    return outputImage;
//}
//
//@end
//
@end
