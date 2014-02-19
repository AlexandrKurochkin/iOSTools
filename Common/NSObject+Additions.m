//
//  NSObject+Additions.m
//  iOSTools
//
//  Created by Alex Kurochkin on 7/24/13.
//  Copyright (c) 2013 Alex Kurochkin. All rights reserved.
//

#import "NSObject+Additions.h"
#import <objc/runtime.h>

@implementation NSObject (Additions)

- (void)clean {
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *property_name = property_getName(property);
        const char *property_type = property_getAttributes(property);
        
        switch(property_type[1]) {
            case 'f' : //float
                break;
            case 's' : //short
                break;
            case '@' : //ObjC object
                //Handle different clases in here
                [self setValue:nil forKey:[NSString stringWithUTF8String:property_name]];
                break;
        }
    }
    free(properties);
}

@end
