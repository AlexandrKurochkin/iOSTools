//
//  NSObject+Additions.m
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

#import "NSObject+Additions.h"
#import <objc/runtime.h>
#import <malloc/malloc.h>
#import "iOSTools.h"

@implementation NSObject (Additions)

- (void)clean {
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *property_name = property_getName(property);
        const char *property_type = property_getAttributes(property);
        
        NSString *s = [NSString stringWithUTF8String:property_name];
        //CRUTCH for fuccking iOS8
        if ([s isEqual:@"description"] ||
            [s isEqual:@"debugDescription"]) {
            continue;
        }
        
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

#pragma mark - work properties

- (NSArray *)listOfProperties {
    return [NSObject listOfPropertiesOfClass:[self class]];
}

+ (NSArray *)listOfPropertiesOfClass:(Class)aClass {
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList(aClass, &propertyCount);
    
    NSMutableArray * propertyNames = [NSMutableArray array];
    for (unsigned int i = 0; i < propertyCount; ++i) {
        [propertyNames addObject:[NSString stringWithUTF8String:property_getName(properties[i])]];
    }
    free(properties);
    //    NSLog(@"Names: %@", propertyNames);
    return [NSArray arrayWithArray:propertyNames];
}

+ (NSArray *)listOfPropertiesOfClass:(Class)aClass untilSuperClass:(Class)untilSuperClass {
    

    NSMutableArray * propertyNames = [NSMutableArray array];
    
    const char *untilClassName = class_getName(untilSuperClass);
    
    Class currentClass = aClass;
    const char *currentClassName = class_getName(currentClass);
    ;
    
    while (strcmp(untilClassName, currentClassName)) {
        [propertyNames addObjectsFromArray:[NSObject listOfPropertiesOfClass:currentClass]];
        currentClass = class_getSuperclass(currentClass);
        currentClassName = class_getName(currentClass);
    }

    return [NSArray arrayWithArray:propertyNames];
}

- (NSDictionary *) dictionaryWithProperties {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [self completeObject:dict fromSourceObject:self];
    return [NSDictionary dictionaryWithDictionary:dict];
}



- (void)completeObject:(id)object fromSourceObject:(id)sourceObject {
    
    NSArray *keys = [NSObject listOfPropertiesOfClass:[sourceObject class] untilSuperClass:[NSObject class]];
    
    for (NSString *key in keys) {
        
        if ([key isEqualToString:@"locations"]) {
            
        }
        
        id value = [sourceObject valueForKey:key];
        value = (value != nil) ? value : [NSNull null];
        
        if ([object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSMutableDictionary class]]) {
            [object setObject:value forKey:key];
        } else {
            [object setValue:value forKey:key];
        }
        
    }
}

//- (void)completeObject:(id)object fromSourceObject:(id)sourceObject {
//    unsigned count;
//    objc_property_t *properties = class_copyPropertyList([sourceObject class], &count);
//    
//    for (int i = 0; i < count; i++) {
//        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
//        id value = [sourceObject valueForKey:key];
//        value = (value != nil) ? value : [NSNull null];
//        
//        if ([object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSMutableDictionary class]]) {
//            [object setObject:value forKey:key];
//        } else {
//            [object setValue:value forKey:key];
//        }
//    }
//    free(properties);
//}

- (id)createClone {
    id clone = [[self class] new];
    [self completeObject:clone fromSourceObject:self];
    return clone;
}

- (BOOL)isSimilar:(id)obj {
    BOOL returnValue = YES;
    
    if ([obj isKindOfClass:[self class]]) {
        NSArray *keys = [NSObject listOfPropertiesOfClass:[self class] untilSuperClass:[NSObject class]];
        
        for (NSString *key in keys) {
            id value1 = [self valueForKey:key];
            id value2 = [obj valueForKey:key];
            
            BOOL isBothNilOrNSNull = ((value1 == nil && [value2 isKindOfClass:[NSNull class]]) ||
                                      (value2 == nil && [value1 isKindOfClass:[NSNull class]]));
            
            if (!isBothNilOrNSNull) {
                if (![value1 isEqual:value2]) {
                    returnValue = NO;
                    break;
                }
            }
        }
    } else {
        returnValue = NO;
    }
    
    
//    NSArray *keys2 = [NSObject listOfPropertiesOfClass:[obj class] untilSuperClass:[NSObject class]];
    
    return returnValue;
}

- (void)printAllData {
    DLog(@"<%@: %@> \nProperties: \n%@", NSStringFromClass([self class]), [NSString stringWithFormat:@"%p",self], [self dictionaryWithProperties]);
}

- (void)printObjectSize {
    NSLog(@"<%@> size : %zd", self, malloc_size((__bridge const void *)(self)));
}

@end
