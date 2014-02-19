//
//  UIView+Additions.m
//  WheninMerchant_ios
//
//  Created by Alex Kurochkin on 2/19/14.
//  Copyright (c) 2014 Alex Kurochkin. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView (Additions)

- (void)rounderCorners:(UIRectCorner)corners radius:(CGFloat)radius {
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(radius, radius)];
    
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    
    // Set the newly created shape layer as the mask for the image view's layer
    self.layer.mask = maskLayer;
}

@end
