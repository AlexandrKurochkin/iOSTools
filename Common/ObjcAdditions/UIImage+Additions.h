//
//  UIImage+Additions.h
//  WheninMerchant_ios
//
//  Created by Alex Kurochkin on 6/21/14.
//  Copyright (c) 2014 Alex Kurochkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Additions)

- (UIImage *)imageScaledToSize:(CGSize)newSize;
- (UIImage *)imageProportionalScaledToSize:(CGSize)newSize;

@end
