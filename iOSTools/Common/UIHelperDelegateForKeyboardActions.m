//
//  UIHelperDelegateForKeyboardActions.m
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

#import "UIHelperDelegateForKeyboardActions.h"
#import "iOSTools.h"

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
    if (IS_LANDSCAPE_CURRENT_DEVICE_ORIENTATION)
        [self moveFieldsOn:_newY];
}

- (void)moveDownFields {
    if (IS_LANDSCAPE_CURRENT_DEVICE_ORIENTATION)
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
