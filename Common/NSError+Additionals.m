//
//  NSError+Additionals.m
//  iOSTools
//
//  Created by Alex Kurochkin on 7/19/13.
//  Copyright (c) 2013 Alex Kurochkin. All rights reserved.
//

#import "NSError+Additionals.h"

@implementation NSError (Additionals)

- (void)print {
    NSLog(@"error code: %d", [self code]);
    NSLog(@"error domain: %@", [self domain]);
    NSLog(@"error userInfo: %@", [self userInfo]);
}

@end
