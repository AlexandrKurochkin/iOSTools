//
//  NSString+Additions.m
//  iOSTools
//
//  Created by Alex Kurochkin on 11/6/13.
//  Copyright (c) 2013 Alex Kurochkin. All rights reserved.
//

#import "NSString+Additions.h"

#define kDigitalKey                         @"1234567890."
#define kNaturalDigitalKey                  @"1234567890"

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

- (BOOL)isNaturalNumber {
    BOOL valid = [[self stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:kNaturalDigitalKey]] isEqualToString:@""];
    
    BOOL isValidate = (valid && [self integerValue] > 0);
    return isValidate;
}

@end
