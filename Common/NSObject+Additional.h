//
//  NSObject+Additional.h
//  WheniniOS
//
//  Created by Alex Kurochkin on 7/24/13.
//  Copyright (c) 2013 Alex Kurochkin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEALLOC - (void)dealloc { [self clean];[super dealloc];}

@interface NSObject (Additional)

- (void)clean;

@end
