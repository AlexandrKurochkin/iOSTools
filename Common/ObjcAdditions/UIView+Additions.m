//
//  UIView+Additions.m
//  https://github.com/AlexandrKurochkin/iOSTools
//  Licensed under the terms of the BSD License, as specified below.
//
/*
 Copyright (c) 2014, Alexandr Kurochkin
 
 All rights reserved.
 
 * Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice,
 this list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 * Neither the name of the iOSTools nor the names of its contributors may be used
 to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "UIView+Additions.h"
#import <objc/runtime.h>

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

/*
    Show Activity indicator
*/

NSString * const kDHStyleKey = @"kDHStyleKey";

@implementation UIView (ShowActivityView)


- (void)setActivityView:(UIActivityIndicatorView *)aView {
	objc_setAssociatedObject(self,  (__bridge const void *)(kDHStyleKey), aView, OBJC_ASSOCIATION_RETAIN);
}

- (UIActivityIndicatorView *)activityView {
	return objc_getAssociatedObject(self, (__bridge const void *)(kDHStyleKey));
}


- (void)setupLoadingView {
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityView.color = [UIColor colorWithRed:42.0f/255.0f green:170.0f/255.0f blue:242.0f/255.0f alpha:1.0f];
    self.activityView.center = self.center;
    [self addSubview:self.activityView];
    
    self.activityView.hidden = YES;
}

- (void)showLoadingOnView {
    
    if (self.activityView == nil) {
        [self setupLoadingView];
    }
    
    self.activityView.center = self.center;
    self.activityView.hidden = NO;
    [self.activityView startAnimating];
    [self bringSubviewToFront:self.activityView];
}

- (void)hideLoadingOnView {
    [self.activityView stopAnimating];
    self.activityView.hidden = YES;
}


@end
