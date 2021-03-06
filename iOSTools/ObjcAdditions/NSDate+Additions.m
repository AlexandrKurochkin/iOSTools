//
//  NSDate+Additions.m
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

#import "NSDate+Additions.h"

@implementation NSDate (Additions)

+ (NSDate *)dateOfBirthOfMinimalValidateAge:(NSInteger)minAge {
    NSCalendar * gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSDateComponents * components = [gregorian components:unitFlags fromDate:[NSDate date]];
    [components setYear:[components year] - minAge];
    return [gregorian dateFromComponents:components];
}

- (BOOL)isValideForMinAge:(NSInteger)minAge {
    
    NSCalendar * gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSDateComponents * components = [gregorian components:unitFlags fromDate:[NSDate date]];
    [components setYear:[components year] - minAge];
    NSDate *maxDate = [gregorian dateFromComponents:components];
    
    return ([self compare:maxDate] != NSOrderedDescending) ? YES : NO;
}

+ (NSDate *)dateFromString:(NSString *)dateString format:(NSString *)format {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    NSDate *date = [dateFormat dateFromString:dateString];
    return date;
}

- (NSString *)dateStringForFormat:(NSString *)format {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    NSString *dateStr = [dateFormat stringFromDate:self];
    return dateStr;
}

- (NSComparisonResult)compareWithoutSeconds:(NSDate *)aDate {
    NSCalendar *cal = [NSCalendar currentCalendar];
//    NSCalendarUnitMinute
    NSCalendarUnit param = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *date1Components = [cal components:param fromDate:self];
    NSDateComponents *date2Components = [cal components:param fromDate:aDate];
    NSComparisonResult comparison = [[cal dateFromComponents:date1Components] compare:[cal dateFromComponents:date2Components]];
    return comparison;
}

- (NSDate *)dateWithCurrentDate {
    //gather current calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    
    //gather date components from date
    NSDateComponents *currentDateComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:[NSDate date]];
    
    NSDateComponents *oldDateComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:self];
    
    //set date components
    currentDateComponents.hour    = oldDateComponents.hour;
    currentDateComponents.minute  = oldDateComponents.hour;

    //save date relative from date
    NSDate *returnDate = [calendar dateFromComponents:currentDateComponents];
    return returnDate;
}

- (NSInteger)daysToNSDate:(NSDate *)endDate {
    NSDateComponents *components;
    NSInteger days;
    
    components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay
                                                 fromDate: self toDate: endDate options: 0];
    days = [components day];
    return days;
}

- (NSDate *)dateWithAddedDays:(NSInteger)addDaysCount {
    
    // Create and initialize date component instance
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:addDaysCount];
    
    // Retrieve date with increased days count
    NSDate *newDate = [[NSCalendar currentCalendar]
                       dateByAddingComponents:dateComponents
                       toDate:self options:0];
    return newDate;
}

- (NSDate *)dateWithAddedHours:(NSInteger)addHoursCount {
    return [self dateByAddingTimeInterval:60*60*addHoursCount]; 
}

@end
