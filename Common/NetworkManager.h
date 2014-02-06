//
//  NetworkManager.h
//
//  Created by Alexandr Kurochkin on 6/12/12.
//  Copyright (c) 2012 OneClickDev. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    NoConnectionType = 0,
    CellConnectionType,
    WifiConnectionType
} NetworkConectionType;

@interface NetworkManager : NSObject

+ (NetworkConectionType)currentNetworkConnectionType;
+ (BOOL)isNetworkConcet;

@end
