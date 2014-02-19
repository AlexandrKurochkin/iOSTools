//
//  KeyboardListener.h
//  WheninMerchant_ios
//
//  Created by Alex Kurochkin on 2/19/14.
//  Copyright (c) 2014 Alex Kurochkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyboardListener : NSObject

@property (nonatomic, unsafe_unretained, readonly) BOOL isVisible;

+ (instancetype)sharedListener;

@end
