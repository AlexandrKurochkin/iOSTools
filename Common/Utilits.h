//
//  Utilits.h
//  RestKitTest3
//
//  Created by Alex Kurochkin on 7/11/13.
//  Copyright (c) 2013 Alex Kurochkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilits : NSObject

+ (NSArray *)listOfPropertiesOfClass:(Class)class;
+ (NSDictionary *)dictionaryWithPropertiesOfObject:(id)obj;

//UIPart
+ (void)rounderCorners:(UIRectCorner)corners radius:(CGFloat)radius forView:(UIView *)view;

+ (BOOL)isIphone5;
+ (BOOL)NSStringIsValidEmail:(NSString *)checkString;


@end
