//
//  Utilits.m
//  iOSTools
//
//  Created by Alex Kurochkin on 7/11/13.
//  Copyright (c) 2013 Alex Kurochkin. All rights reserved.
//

#import "Utilits.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

@implementation Utilits

+ (NSArray *)listOfPropertiesOfClass:(Class)class {
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList(class, &propertyCount);
    
    NSMutableArray * propertyNames = [NSMutableArray array];
    for (unsigned int i = 0; i < propertyCount; ++i) {
        [propertyNames addObject:[NSString stringWithUTF8String:property_getName(properties[i])]];
    }
    free(properties);
    //    NSLog(@"Names: %@", propertyNames);
    return [NSArray arrayWithArray:propertyNames];
}

+(NSDictionary *) dictionaryWithPropertiesOfObject:(id)obj {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        [dict setObject:[obj valueForKey:key] forKey:key];
    }
    
    free(properties);
    
    return [NSDictionary dictionaryWithDictionary:dict];
}

#pragma mark - UI helpers

+ (void)rounderCorners:(UIRectCorner)corners radius:(CGFloat)radius forView:(UIView *)view {

    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(radius, radius)];
    
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    
    // Set the newly created shape layer as the mask for the image view's layer
    view.layer.mask = maskLayer;
}

+(BOOL)isIphone5 {
    return ([[UIScreen mainScreen] bounds].size.height == 568) ? YES: NO;
}


+ (BOOL) NSStringIsValidEmail:(NSString *)checkString {
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

@end


