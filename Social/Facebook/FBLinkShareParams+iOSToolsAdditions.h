//
//  FBLinkShareParams+iOSToolsAdditions.h
//  WheninMerchant_ios
//
//  Created by Alex Kurochkin on 8/1/14.
//  Copyright (c) 2014 Alex Kurochkin. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>

@interface FBLinkShareParams (iOSToolsAdditions)

+ (instancetype)createWithParametrs:(NSDictionary *)parametrs;

@end
