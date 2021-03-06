//
//  NSObject_VersionHelper.h
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

//Orientation

#define CURRENT_INTERFACE_ORIENTATION               self.interfaceOrientation


#define IS_LANDSCAPE_CURRENT_INTERFACE_ORIENTATION  UIInterfaceOrientationIsLandscape(CURRENT_INTERFACE_ORIENTATION)
#define IS_PORTRAIT_CURRENT_INTERFACE_ORIENTATION   UIInterfaceOrientationIsPortrait(CURRENT_INTERFACE_ORIENTATION)

#define CURRENT_DEVICE_ORIENTATION                  (UIInterfaceOrientation)[[UIDevice currentDevice] orientation]
#define IS_LANDSCAPE_CURRENT_DEVICE_ORIENTATION     UIInterfaceOrientationIsLandscape(CURRENT_DEVICE_ORIENTATION)
#define IS_PORTRAIT_CURRENT_DEVICE_ORIENTATION   UIInterfaceOrientationIsPortrait(CURRENT_DEVICE_ORIENTATION)


//Device Type
#define IS_IPAD                                     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define IS_IPHONE_5                                 ([[UIScreen mainScreen] bounds].size.height == 568) ? YES: NO

//iOS versions
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define CURRENT_BUILD_NUMBER                        [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]
#define CURRENT_APP_VERSION_NUMBER                  [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]

#define CURRENT_APP_VERSION_AND_BUILD_NUMBER          [NSString stringWithFormat:@"Version: %@ (%@)", CURRENT_APP_VERSION_NUMBER, CURRENT_BUILD_NUMBER];
