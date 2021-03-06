//
//  NSString+Additions.m
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

#import "NSString+Additions.h"
#import <CommonCrypto/CommonDigest.h>
#import "iOSTools.h"

#define kDigitalKey                         @"1234567890."
#define kPhoneKey                           @"1234567890.-()+*#"
#define kNaturalDigitalKey                  @"1234567890"

@implementation NSString (Additions)

- (BOOL)isValidEmail {
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
//    return YES;
}

- (BOOL)isContainSubstring:(NSString *)substring {
    return ([self rangeOfString:substring].location == NSNotFound) ? NO : YES;
}

- (BOOL)isNaturalNumber {
    BOOL valid = [[self stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:kNaturalDigitalKey]] isEqualToString:@""];
    
    BOOL isValidate = (valid && [self integerValue] > 0);
    return isValidate;
}

- (BOOL)isValidPhoneNumber {
    return [[self stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:kPhoneKey]] isEqualToString:@""];
}

+ (NSString *)stringWithIntValue:(int)intValue {
    return [NSString stringWithFormat:@"%d",intValue];
}

+ (NSString *)stringWithIntegerValue:(NSInteger)integerValue {
    return [NSString stringWithFormat:@"%ld",(long)integerValue];
}

- (NSString*)MD5
{
    // Create pointer to the string as UTF8
    const char *ptr = [self UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, (CC_LONG)strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

- (BOOL)containsString:(NSString *)substring {
    NSRange range = [self rangeOfString : substring];
    BOOL found = (range.location != NSNotFound);
    return found;
}

- (NSString *)httpSchemeString {
    NSString *returnLink;
    
    NSRange httpRange = [self rangeOfString : @"http://"];
    NSRange httpsRange = [self rangeOfString : @"https://"];
    
    returnLink = (httpRange.location == 0 || httpsRange.location == 0) ? self : [NSString stringWithFormat:@"http://%@", self];
    return returnLink;
}

- (NSURL *)httpSchemeLink {
    return [NSURL URLWithString:self.httpSchemeString];
}

- (BOOL)isValidAsURL {
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:self];
}

- (NSString *)phoneFormated {
    NSString *formatted = self;
    if (self.length == 10) {
        
        NSString *firstSubstr = [self substringWithRange:NSMakeRange(0,3)];
        NSString *secondSubstr = [self substringWithRange:NSMakeRange(3,3)];
        NSString *thirdSubstr = [self substringWithRange:NSMakeRange(6,4)];
        
        formatted = [NSString stringWithFormat: @"(%@) %@-%@", firstSubstr, secondSubstr, thirdSubstr];
        
        DLog(@"self: %@ formatted: %@", self, formatted);
        
    }
    return formatted;
}


@end
