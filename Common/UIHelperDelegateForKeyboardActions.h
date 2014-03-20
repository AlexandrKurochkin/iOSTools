//
//  UIHelperDelegateForKeyboardActions.h
//  WheninMerchant_ios
//
//  Created by Alex Kurochkin on 3/19/14.
//  Copyright (c) 2014 Alex Kurochkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UIHelperDelegateForKeyboardActionsDataSource <NSObject>

- (CGFloat)yDifferents;
- (CGFloat)animationsDuration;

@end

@interface UIHelperDelegateForKeyboardActions : NSObject < UITextFieldDelegate > {
    id <UIHelperDelegateForKeyboardActionsDataSource> _dataSource;
}

@property (nonatomic, weak, readwrite) IBOutlet UIView *contentView;
@property (nonatomic, weak, readwrite) IBOutlet id <UIHelperDelegateForKeyboardActionsDataSource> dataSource;

@end
