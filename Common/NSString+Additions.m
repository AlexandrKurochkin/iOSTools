//
//  NSString+Additions.m
//  WheniniOS
//
//  Created by Alex Kurochkin on 11/6/13.
//  Copyright (c) 2013 Alex Kurochkin. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

- (BOOL)isValidEmail {
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isContainSubstring:(NSString *)substring {
    return ([self rangeOfString:substring].location == NSNotFound) ? NO : YES;
}

@end
