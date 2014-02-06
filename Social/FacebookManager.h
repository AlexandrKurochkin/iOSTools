//
//  FacebookManager.h
//  WheniniOS
//
//  Created by Alex Kurochkin on 7/12/13.
//  Copyright (c) 2013 Alex Kurochkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookManager : NSObject 

@property (nonatomic, retain, readwrite) FBSession *session;

+ (instancetype)sharedManager;

- (void)fetchUserInfoForSender:(id)sender
handlingRequestSuccessSelector:(SEL)requestSuccessSelector
handlingRequestErrorSelector:(SEL)requestErrorSelector;

- (void)postDataWithLink:(NSString *)link
                 picture:(NSString *)picture
                    name:(NSString *)name
                 caption:(NSString *)caption
             description:(NSString *)description;


- (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication;
- (void)appWillTerminate;
- (void)appDidBecomeActive;




@end
