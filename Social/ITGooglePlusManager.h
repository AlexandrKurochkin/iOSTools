//
//  ITGooglePlusManager.h
//  WheninMerchant_ios
//
//  Created by Alex Kurochkin on 1/9/15.
//  Copyright (c) 2015 Alex Kurochkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITGooglePlusManager : NSObject

+ (id)sharedManager;
- (void)postDataWithTitle:(NSString *)aTitle
              description:(NSString *)description
             thumbnailURL:(NSURL *)aThumbnailURL
              prefillText:(NSString *)aprefillText
               URLToShare:(NSURL *)anURLToShare;

@end
