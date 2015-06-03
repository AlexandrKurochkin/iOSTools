//
//  NetworkManager.m
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
