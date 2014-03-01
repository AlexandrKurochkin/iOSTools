//
//  UIView+Additions.m
//  WheninMerchant_ios
//
//  Created by Alex Kurochkin on 2/19/14.
//  Copyright (c) 2014 Alex Kurochkin. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView (Additions)

- (void)setX:(CGFloat)newX { self.frame = CGRectMake(newX, self.y, self.width, self.height);}
- (CGFloat)x { return self.frame.origin.x;}

- (void)setY:(CGFloat)newY { self.frame = CGRectMake(self.x, newY, self.width, self.height);}
- (CGFloat)y { return self.frame.origin.y;}


- (void)setWidth:(CGFloat)newWidth { self.frame = CGRectMake(self.x, self.y, newWidth, self.height);}
- (CGFloat)width { return self.frame.size.width; }

- (void)setHeight:(CGFloat)newHeight { self.frame = CGRectMake(self.x, self.y, self.width, newHeight);}
- (CGFloat)height { return self.frame.size.height;}


- (void)setOrigin:(CGPoint)newOrigin { self.frame = CGRectMake(newOrigin.x, newOrigin.y, self.width, self.height);}
- (CGPoint)origin { return self.frame.origin;}

- (void)setSize:(CGSize)newSize { self.frame = CGRectMake(self.x, self.y, newSize.width, newSize.height);}
- (CGSize)size { return self.frame.size;}

- (void)printFrame {
    DLog(@"%@ frame: %@", NSStringFromClass([self class]), NSStringFromCGRect(self.frame));
}


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
