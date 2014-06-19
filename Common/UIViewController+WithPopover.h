//
//  UIViewController+WithPopover.h
//  WheninMerchant_ios
//
//  Created by Alex Kurochkin on 6/19/14.
//  Copyright (c) 2014 Alex Kurochkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (WithPopover) < UIPopoverControllerDelegate >

@property (nonatomic, strong, readwrite) UIPopoverController* currentPopover;

- (void)showPopoverForViewController:(UIViewController *)viewController inView:(UIView *)view withFrame:(CGRect)frame  arrowDirections:(UIPopoverArrowDirection)arrowDirections contentSize:(CGSize)contentSize;

- (void)showPopoverForViewController:(UIViewController *)viewController inView:(UIView *)view withFrame:(CGRect)frame;

@end
