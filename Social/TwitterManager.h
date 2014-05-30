//
//  TwitterManager.h
//  WheniniOS
//
//  Created by Alex Kurochkin on 7/16/13.
//  Copyright (c) 2013 Alex Kurochkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwitterManager : NSObject

+ (id)sharedManager;
+ (void)twitMessage:(NSString *)message;
+ (void)postImage:(UIImage *)image withStatus:(NSString *)status;

@end
