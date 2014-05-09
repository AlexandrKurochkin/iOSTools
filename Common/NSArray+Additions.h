//
//  NSArray+Additions.h
//  WheninMerchant_ios
//
//  Created by Alex Kurochkin on 5/8/14.
//  Copyright (c) 2014 Alex Kurochkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Additions)

- (NSArray *)arrayWithRemovedObjectAtIndex:(NSInteger)index;
- (NSArray *)arrayWithRemovedObject:(id)obj;

@end
