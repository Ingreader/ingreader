//
//  KWBinarizeFilter.h
//  ingreader
//
//  Created by Kamila Wojciechowska on 05.07.2014.
//  Copyright (c) 2014 silk. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>

@interface KWBinarizeFilter : CIFilter
@property (retain, nonatomic) CIImage *inputImage;
@property (copy, nonatomic) NSNumber *inputThreshold;

@end
