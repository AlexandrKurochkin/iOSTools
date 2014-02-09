//
//  NSString+Additions.h
//  iOSTools
//
//  Created by Alex Kurochkin on 11/6/13.
//  Copyright (c) 2013 Alex Kurochkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

- (BOOL)isValidEmail;
- (BOOL)isContainSubstring:(NSString *)substring;

@end
