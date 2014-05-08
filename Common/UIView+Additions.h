//
//  UIView+Additions.h
//  iOSTools
//
//  Created by Alex Kurochkin on 2/19/14.
//  Copyright (c) 2014 Alex Kurochkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Additions)

- (void)setX:(CGFloat)newX;
- (CGFloat)x;

- (void)setY:(CGFloat)newY;
- (CGFloat)y;


- (void)setWidth:(CGFloat)newWidth;
- (CGFloat)width;

- (void)setHeight:(CGFloat)newHeight;
- (CGFloat)height;


- (void)setOrigin:(CGPoint)newOrigin;
- (CGPoint)origin;

- (void)setSize:(CGSize)newSize;
- (CGSize)size;

- (void)rounderCorners:(UIRectCorner)corners radius:(CGFloat)radius;

- (void)printFrame;

@end


/*
 Show Activity indicator
*/


@interface UIView (ShowActivityView)

@property (nonatomic, strong, readwrite) UIActivityIndicatorView *activityView;

- (void)showLoadingOnView;
- (void)hideLoadingOnView;

@end

