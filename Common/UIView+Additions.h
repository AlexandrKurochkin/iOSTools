//
//  UIView+Additions.h
//  iOSTools
//
//  Created by Alex Kurochkin on 2/19/14.
//  Copyright (c) 2014 Alex Kurochkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Additions)

- (void)rounderCorners:(UIRectCorner)corners radius:(CGFloat)radius;

- (CGFloat)x;
- (CGFloat)y;
- (CGFloat)width;
- (CGFloat)height;

@end
