//
//  FacebookManager.m
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

#import "FacebookManager.h"
#import "FBLinkShareParams+iOSToolsAdditions.h"

NSString *const kDefaultLink    = @"http://alex-kurochkin.com/";

@interface FacebookManager ()

@end

@implementation FacebookManager

+ (instancetype)sharedManager {
    static FacebookManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [FacebookManager new];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

ARC_DEALLOC


#pragma mark - Facebook life cicle

- (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication {
    return  [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

- (void)appWillTerminate {
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (void)appDidBecomeActive {
    [FBAppCall handleDidBecomeActive];
}

#pragma mark - fetch user data

- (void)fetchUserInfoWithSuccessHandler:(FBMSuccessFetchedUserInfo)successHandler
                         failureHandler:(FBMFailure)failureHandler {
    
    
    //Handeler User Info fetch request
    FBRequestHandler requestUserInfoHandler = ^(FBRequestConnection *connection,
                                                id <FBGraphUser> user,
                                                NSError *error) {
        if (error != nil) {
            [error print];
            failureHandler(error);
        } else {
            NSLog(@"userInfo: %@", user);
            successHandler(user);
        }
    };
    
    
    //Handler of open facebook Session Request
    FBSessionStateHandler sessionStateHandler = ^(FBSession *session,
                                                  FBSessionState status,
                                                  NSError *error) {
        
        DLog(@"session: %@",session);
        if (error != nil) {
            [error print];
            failureHandler(error);
        } else {
            [FBRequestConnection startWithGraphPath:@"me" completionHandler:requestUserInfoHandler];
        }
    };
    
    [[FBSession activeSession] closeAndClearTokenInformation];
    [FBSession setActiveSession:nil];
    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile'", @"email", @"user_birthday"]
                                       allowLoginUI:YES
                                  completionHandler:sessionStateHandler];
    
}

#pragma mark - post data to facebook

- (void)postDataWithLink:(NSString *)link
                 picture:(NSString *)picture
                    name:(NSString *)name
                 caption:(NSString *)caption
             description:(NSString *)description {
    
    //    //Validate and create FB share parameters
    
    NSString *updatedLink = link.httpSchemeString;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"name"]               = name;
    dict[@"caption"]            = caption;
    dict[@"description"]        = description;
    dict[@"link"]               = (updatedLink.isValidAsURL) ? updatedLink : kDefaultLink;
    dict[@"picture"]            = picture;
    
    
    
    DLog(@"Post Params: %@", dict);
    
    //Test worked post parametrs
    //    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
    //                                   @"Sharing Tutorial", @"name",
    //                                   @"Build great social apps and get more installs.", @"caption",
    //                                   @"Allow your users to share stories on Facebook from your app using the iOS SDK.", @"description",
    //                                   @"https://developers.facebook.com/docs/ios/share/", @"link",
    //                                   @"http://i.imgur.com/g3Qc1HN.png", @"picture",
    //                                   nil];
    
    //Use posting from WebView because now posting from app have a problem
    //    [self shareToFacebookFromWebView:dict];
    [self shareWithParams:dict];
}


- (void)shareWithParams:(NSDictionary *)parametrs {
    
    if ([FBDialogs canPresentShareDialog]) {
        [self shareToFacebookFromFBApp:parametrs];
        // If the Facebook app is NOT installed and we can't present the share dialog
    } else {
        // FALLBACK: publish just a link using the Feed dialog
        // Show the feed dialog
        [self shareToFacebookFromWebView:parametrs];
    }
}

- (void)shareToFacebookFromFBApp:(NSDictionary *)parametrs {
    FBLinkShareParams *params = [FBLinkShareParams createWithParametrs:parametrs];
    
    //    BOOL b = [FBDialogs canPresentShareDialogWithParams:params];
    [FBDialogs presentShareDialogWithParams:params
                                clientState:nil
                                    handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                        if(error) {
                                            [self errorHandler:error];
                                        } else {
                                            // Success
                                            NSLog(@"result %@", results);
                                        }
                                    }];
}

- (void)shareToFacebookFromWebView:(NSDictionary *)parametrs {
    [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                           parameters:parametrs
                                              handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                  if (error) {
                                                      [self errorHandler:error];
                                                  } else {
                                                      if (result == FBWebDialogResultDialogNotCompleted) {
                                                          // User canceled.
                                                          NSLog(@"User cancelled.");
                                                      } else {
                                                          // Handle the publish feed callback
                                                          NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                          
                                                          if (![urlParams valueForKey:@"post_id"]) {
                                                              // User canceled.
                                                              NSLog(@"User cancelled.");
                                                              
                                                          } else {
                                                              // User clicked the Share button
                                                              NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                              NSLog(@"result %@", result);
                                                          }
                                                      }
                                                  }
                                              }];
}

#pragma mark - additional functions

- (void)errorHandler:(NSError *)error {
    // An error occurred, we need to handle the error
    // See: https://developers.facebook.com/docs/ios/errors
    //                                            NSLog(@"Error publishing story: %@", error.description);
    DLog(@"FaceBook Error:");
    [error print];
    
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        NSString *userMessageForError = [FBErrorUtility userMessageForError:error];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:userMessageForError delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

@end




