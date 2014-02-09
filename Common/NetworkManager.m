//
//  NetworkManager.m
//  iOSTools
//  Created by Alexandr Kurochkin on 6/12/12.
//  Copyright (c) 2012 OneClickDev. All rights reserved.
//

#import "NetworkManager.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>


@implementation NetworkManager


+ (NetworkConectionType)currentNetworkConnectionType {
    // Part 1 - Create Internet socket addr of zero
	struct sockaddr_in zeroAddr;
	bzero(&zeroAddr, sizeof(zeroAddr));
	zeroAddr.sin_len = sizeof(zeroAddr);
	zeroAddr.sin_family = AF_INET;
    
	// Part 2- Create target in format need by SCNetwork
	SCNetworkReachabilityRef target = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *) &zeroAddr);
    
	// Part 3 - Get the flags
	SCNetworkReachabilityFlags flags;
	SCNetworkReachabilityGetFlags(target, &flags);
    CFRelease(target);
    //CFRelease(&zeroAddr);
    //free(&zeroAddr);
    //[target CF]
    
	// Part 4 - Create output
//	NSString *sNetworkReachable;
    BOOL isConnection = NO;
	if (flags & kSCNetworkFlagsReachable) {
//		sNetworkReachable = @"YES";
        isConnection = YES;
    } else {
//		sNetworkReachable = @"NO";
        isConnection = NO;
    }
//    
//	NSString *sCellNetwork;
    BOOL isCellConnection = NO;
	if (flags & kSCNetworkReachabilityFlagsIsWWAN) {
//		sCellNetwork = @"YES";
        isCellConnection = YES;
	} else {
//		sCellNetwork = @"NO";
        isCellConnection = NO;
    }
    
//    DLog(@"IS CONECTION:%@", sNetworkReachable);
//    DLog(@"IS CELL CONECTION:%@", sCellNetwork);
    
    NetworkConectionType connectionType = NoConnectionType;
    
    if (isConnection) {
        if (isCellConnection) {
            connectionType = CellConnectionType;
        } else {
            connectionType = WifiConnectionType;
        }
    } else {
        connectionType = NoConnectionType;
    }
    return connectionType;
}

+ (BOOL)isNetworkConcet {
    BOOL returnValue = NO;
    switch ([self currentNetworkConnectionType]) {
        case NoConnectionType: {
            returnValue = NO;
            break;
        }
            
        default: {
            returnValue = YES;
            break;
        }
    }
    return returnValue;
}

@end
