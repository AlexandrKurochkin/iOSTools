//
//  UIHelperDelegateForKeyboardActions.m
//  WheninMerchant_ios
//
//  Created by Alex Kurochkin on 3/19/14.
//  Copyright (c) 2014 Alex Kurochkin. All rights reserved.
//

#import "UIHelperDelegateForKeyboardActions.h"

@interface UIHelperDelegateForKeyboardActions () {
    CGFloat _oldY;
    CGFloat _newY;
    
    CGFloat _yDif;
    CGFloat _animationDurations;
}


@end

@implementation UIHelperDelegateForKeyboardActions

@synthesize contentView;
@dynamic dataSource;


#pragma mark - properties


- (void)setDataSource:(id<UIHelperDelegateForKeyboardActionsDataSource>)dataSource {
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        [self setupParametrs];
    }
}

- (id<UIHelperDelegateForKeyboardActionsDataSource>)dataSource {
    return _dataSource;
}

- (void)setupParametrs {
    _yDif = [self.dataSource yDifferents];
    _animationDurations = [self.dataSource animationsDuration];
    
    _oldY = self.contentView.frame.origin.y;
    _newY = _oldY - _yDif;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self moveDownFields];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self moveUpFields];
}

- (void)myKeyboardWillHideHandler:(NSNotification *)notification {
    [self moveDownFields];
}

#pragma mark - animations

- (void)moveUpFields {
    if (IS_LANDSCAPE_CURRENT_INTERFACE_ORIENTATION)
        [self moveFieldsOn:_newY];
}

- (void)moveDownFields {
    if (IS_LANDSCAPE_CURRENT_INTERFACE_ORIENTATION)
        [self moveFieldsOn:_oldY];
}

- (void)moveFieldsOn:(CGFloat)newY {
    if (self.contentView.frame.origin.y != newY) {
        CGRect newFrame = self.contentView.frame;
        newFrame.origin.y = newY;
        [UIView animateWithDuration:_animationDurations animations:^{
            self.contentView.frame = newFrame;
        }];
    }
}



@end
