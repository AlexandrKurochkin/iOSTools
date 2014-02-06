//
//  NSDate+Additions.m
//  WheniniOS
//
//  Created by Alex Kurochkin on 9/9/13.
//  Copyright (c) 2013 Alex Kurochkin. All rights reserved.
//

#import "NSDate+Additions.h"

@implementation NSDate (Additions)

+ (NSDate *)dateOfBirthOfMinimalValidateAge:(NSInteger)minAge {
    NSCalendar * gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    
    NSDateComponents * components = [gregorian components:unitFlags fromDate:[NSDate date]];
    [components setYear:[components year] - minAge];
    return [gregorian dateFromComponents:components];
}

- (BOOL)isValideForMinAge:(NSInteger)minAge {
    
    NSCalendar * gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    
    NSDateComponents * components = [gregorian components:unitFlags fromDate:[NSDate date]];
    [components setYear:[components year] - minAge];
    NSDate *maxDate = [gregorian dateFromComponents:components];
    
    return ([self compare:maxDate] != NSOrderedDescending) ? YES : NO;
}

+ (NSDate *)dateFromString:(NSString *)dateString format:(NSString *)format {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    NSDate *date = [dateFormat dateFromString:dateString];
    [dateFormat release];
    return date;
}

- (NSString *)dateStringForFormat:(NSString *)format {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    NSString *dateStr = [dateFormat stringFromDate:self];
    [dateFormat release];
    return dateStr;
}

@end
