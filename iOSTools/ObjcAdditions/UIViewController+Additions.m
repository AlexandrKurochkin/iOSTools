//
//  UIViewController+Additions.m
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

#import "UIViewController+Additions.h"
#import <objc/runtime.h>
#import "iOSTools.h"

NSString * const kPopOverKey            = @"kPopOverKey";
NSString * const kCurrentEditingString  = @"kCurrentEditingString";

@implementation UIViewController (WithPopover)


- (void)setCurrentPopover:(UIPopoverController *)currentPopover {
    objc_setAssociatedObject(self,  (__bridge const void *)(kPopOverKey), currentPopover, OBJC_ASSOCIATION_RETAIN);
}


- (UIPopoverController *)currentPopover {
	return objc_getAssociatedObject(self, (__bridge const void *)(kPopOverKey));
}

- (void)setCurrentEditingString:(NSString *)currentEditingString {
    objc_setAssociatedObject(self,  (__bridge const void *)(kCurrentEditingString), currentEditingString, OBJC_ASSOCIATION_RETAIN);
}

- (NSString *)currentEditingString {
    return objc_getAssociatedObject(self, (__bridge const void *)(kCurrentEditingString));
}

- (void)showPopoverForViewController:(UIViewController *)viewController inView:(UIView *)view withFrame:(CGRect)frame  arrowDirections:(UIPopoverArrowDirection)arrowDirections contentSize:(CGSize)contentSize {
    
    UIPopoverController* aPopover = [[UIPopoverController alloc]initWithContentViewController:viewController];
    
    
    if (!CGSizeEqualToSize(contentSize, CGSizeZero)) {
        [aPopover setPopoverContentSize:contentSize animated:YES];
    }
    
    frame.origin.x = frame.size.width/2;
    frame.size.width = 1;
    aPopover.popoverLayoutMargins = UIEdgeInsetsMake(0, frame.origin.x, 0, 0);
    
    //    self.currentPopover = nil;
    self.currentPopover = aPopover;
    self.currentPopover.delegate = self;
    [self.currentPopover presentPopoverFromRect:frame
                                         inView:view
                       permittedArrowDirections:arrowDirections
                                       animated:YES];
}


- (void)showPopoverForViewController:(UIViewController *)viewController inView:(UIView *)view withFrame:(CGRect)frame {
    
    [self showPopoverForViewController:viewController inView:view withFrame:frame arrowDirections:UIPopoverArrowDirectionDown contentSize:viewController.view.size];
}

- (BOOL)isCurrentFieldWasEdited:(NSString *)chengedText {
    return (![self.currentEditingString isEqualToString:chengedText]);
}


@end
