//
//  UIImage+Additions.m
//  WheninMerchant_ios
//
//  Created by Alex Kurochkin on 6/21/14.
//  Copyright (c) 2014 Alex Kurochkin. All rights reserved.
//

#import "UIImage+Additions.h"

@implementation UIImage (Additions)

- (CGSize)proportionalResize:(CGSize)sourceSize toSize:(CGSize)destinationsSize {
	float factorWidth = destinationsSize.width/sourceSize.width;
	float factorHeight = destinationsSize.height/sourceSize.height;
	CGSize newSize;
	if (factorWidth > factorHeight ) {
		newSize.width = (unsigned int)floor(sourceSize.width*factorHeight + 0.5);
		newSize.height = (unsigned int)floor(sourceSize.height*factorHeight + 0.5);
	} else {
		newSize.width = (unsigned int)floor(sourceSize.width*factorWidth + 0.5);
		newSize.height = (unsigned int)floor(sourceSize.height*factorWidth + 0.5);
	}
	return newSize;
}


- (UIImage *)imageProportionalScaledToSize:(CGSize)newSize {
    CGSize newProportionalSize = [self proportionalResize:self.size toSize:newSize];
    return [self imageScaledToSize:newProportionalSize];
}

- (UIImage *)imageScaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
