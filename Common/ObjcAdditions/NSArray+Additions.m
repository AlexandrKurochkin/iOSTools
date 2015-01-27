//
//  NSArray+Additions.m
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

#import "NSArray+Additions.h"

@implementation NSArray (Additions)

- (NSArray *)arrayWithRemovedObjectAtIndex:(NSInteger)index {
    NSMutableArray *mArr = [NSMutableArray arrayWithArray:self];
    [mArr removeObjectAtIndex:index];
    return [NSArray arrayWithArray:mArr];
}

- (NSArray *)arrayWithRemovedObject:(id)obj {
    NSMutableArray *mArr = [NSMutableArray arrayWithArray:self];
    [mArr removeObject:obj];
    return [NSArray arrayWithArray:mArr];
}

- (NSArray *)arrayWithAddedObject:(id)obj {
    NSMutableArray *mArr = [NSMutableArray arrayWithArray:self];
    [mArr addObject:obj];
    return [NSArray arrayWithArray:mArr];
}

//- (BOOL)isObjectInArray:(id)obj {
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstName==%@ OR lastName==%@",@"Ken",@"Ken"];
//    NSArray *results = [self filteredArrayUsingPredicate:predicate];
//}

- (NSArray *)arrayWithReplacedObjectAtIndex:(NSInteger)index withObject:(id)obj {
    NSMutableArray *mArr = [NSMutableArray arrayWithArray:self];
    [mArr replaceObjectAtIndex:index withObject:obj];
    return [NSArray arrayWithArray:mArr];
}
 
- (NSArray *)arrayWithReplacedObject:(id)sourceObj destinationObject:(id)destinationObject {
    NSInteger indexOfSourceObj = [self indexOfObject:sourceObj];
    return [self arrayWithReplacedObjectAtIndex:indexOfSourceObj withObject:destinationObject];
}


@end
