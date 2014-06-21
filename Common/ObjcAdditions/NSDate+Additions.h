//
//  NSDate+Additions.h
//  iOSTools
//
//  Created by Alex Kurochkin on 9/9/13.
//  Copyright (c) 2013 Alex Kurochkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Additions)

+ (NSDate *)dateOfBirthOfMinimalValidateAge:(NSInteger)minAge;
+ (NSDate *)dateFromString:(NSString *)dateString format:(NSString *)format;

- (NSString *)dateStringForFormat:(NSString *)format;
- (BOOL)isValideForMinAge:(NSInteger)minAge;

@end
