//
//  NSArray+Additions.m
//  WheninMerchant_ios
//
//  Created by Alex Kurochkin on 5/8/14.
//  Copyright (c) 2014 Alex Kurochkin. All rights reserved.
//

#import "NSArray+Additions.h"

@implementation NSArray (Additions)

- (NSArray *)arrayWithRemovedObjectAtIndex:(NSInteger)index {
    NSMutableArray *mArr = [NSMutableArray arrayWithArray:self];
    [mArr removeObjectAtIndex:index];
    return [NSArray arrayWithArray:mArr];
}

@end
