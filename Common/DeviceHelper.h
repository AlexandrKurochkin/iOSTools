//
//  NSObject_VersionHelper.h
//  iOSTools
//
//  Created by Alex Kurochkin on 2/9/14.
//  Copyright (c) 2014 Alex Kurochkin. All rights reserved.
//

//Orientation

#define CURRENT_INTERFACE_ORIENTATION               self.interfaceOrientation


#define IS_LANDSCAPE_CURRENT_INTERFACE_ORIENTATION  UIInterfaceOrientationIsLandscape(CURRENT_INTERFACE_ORIENTATION)
#define IS_PORTRAIT_CURRENT_INTERFACE_ORIENTATION   UIInterfaceOrientationIsPortrait(CURRENT_INTERFACE_ORIENTATION)

#define CURRENT_DEVICE_ORIENTATION                  [[UIDevice currentDevice] orientation]
#define IS_LANDSCAPE_CURRENT_DEVICE_ORIENTATION     UIInterfaceOrientationIsLandscape(CURRENT_DEVICE_ORIENTATION)
#define IS_PORTRAIT_CURRENT_DEVICE_ORIENTATION   UIInterfaceOrientationIsPortrait(CURRENT_DEVICE_ORIENTATION)


//Device Type

#define IS_IPHONE_5                                 ([[UIScreen mainScreen] bounds].size.height == 568) ? YES: NO

//iOS versions
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

