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

- (NSArray *)inputKeys {
    return @[@"inputImage",@"inputThreshold"];
}

- (NSArray *)outputKeys {
    return @[@"outputImage"];
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

@end
