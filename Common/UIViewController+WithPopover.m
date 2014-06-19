//
//  UIViewController+WithPopover.m
//  WheninMerchant_ios
//
//  Created by Alex Kurochkin on 6/19/14.
//  Copyright (c) 2014 Alex Kurochkin. All rights reserved.
//

#import "UIViewController+WithPopover.h"
#import <objc/runtime.h>

NSString * const kPopOverKey = @"kPopOverKey";

@implementation UIViewController (WithPopover)


- (void)setCurrentPopover:(UIPopoverController *)currentPopover {
    objc_setAssociatedObject(self,  (__bridge const void *)(kPopOverKey), currentPopover, OBJC_ASSOCIATION_RETAIN);
}


- (UIPopoverController *)currentPopover {
	return objc_getAssociatedObject(self, (__bridge const void *)(kPopOverKey));
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

@end
