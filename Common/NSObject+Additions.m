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
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([sourceObject class], &count);
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [sourceObject valueForKey:key];
        value = (value != nil) ? value : [NSNull null];
        
        if ([object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSMutableDictionary class]]) {
            [object setObject:value forKey:key];
        } else {
            [object setValue:value forKey:key];
        }
    }
    free(properties);
}

- (id)createClone {
    id clone = [[self class] new];
    [self completeObject:clone fromSourceObject:self];
    return clone;
}

- (void)printAllData {
    DLog(@"<%@: %@> \nProperties: \n%@", NSStringFromClass([self class]), [NSString stringWithFormat:@"%p",self], [self dictionaryWithProperties]);
}

@end
