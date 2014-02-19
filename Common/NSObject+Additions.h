//
//  NSObject+Additions.h
//  iOSTools
//
//  Created by Alex Kurochkin on 7/24/13.
//  Copyright (c) 2013 Alex Kurochkin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEALLOC - (void)dealloc { [self clean];[super dealloc];}
#define ARC_DEALLOC - (void)dealloc { [self clean];}

@interface NSObject (Additions)

- (void)clean;

+ (NSArray *)listOfPropertiesOfClass:(Class)aClass;
- (NSArray *)listOfProperties;
- (NSDictionary *) dictionaryWithProperties;

@end
