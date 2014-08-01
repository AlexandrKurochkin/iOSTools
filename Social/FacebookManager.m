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

NSString *const kDefultLink    = @"http://alex-kurochkin.com/";

@interface FBLinkShareParams (Additions)

- (NSDictionary *)dictionary;

@end

@implementation FBLinkShareParams (Additions)

+ (instancetype)createWithParametrs:(NSDictionary *)parametrs {
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    
    params.name             = parametrs[@"name"];
    params.linkDescription  = parametrs[@"description"];
    params.caption          = parametrs[@"caption"];
    params.link             = [parametrs[@"link"] httpSchemeLink];
    params.picture          = [parametrs[@"picture"] httpSchemeLink];

    return params;

}

- (NSDictionary *)dictionary {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (self.link)          [dict setObject:self.link forKey:@"link"];
    if (self.picture)       [dict setObject:self.picture forKey:@"picture"];
    if (self.name)          [dict setObject:self.name forKey:@"name"];
    if (self.caption)       [dict setObject:self.caption forKey:@"caption"];
    if (self.linkDescription)   [dict setObject:self.linkDescription forKey:@"description"];
    
    
    return [NSDictionary dictionaryWithDictionary:dict];
//    return @{@"name":self.name, @"link":self.link, @"picture":self.picture, @"caption":self.caption, @"description":self.description};
}

@end


@interface FacebookManager ()

@end

@implementation FacebookManager


static FacebookManager *sharedInstance = nil;

+ (instancetype)sharedManager {
	if (sharedInstance == nil) {
		sharedInstance = [[self alloc] init];
	}
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

- (void)fetchUserInfoForSender:(id)sender
handlingRequestSuccessSelector:(SEL)requestSuccessSelector
  handlingRequestErrorSelector:(SEL)requestErrorSelector {
    
    [[FBSession activeSession] closeAndClearTokenInformation];
    [FBSession setActiveSession:nil];
    [FBSession openActiveSessionWithReadPermissions:@[@"basic_info", @"email", @"user_birthday"]
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session,
                                                      FBSessionState status,
                                                      NSError *error) {
                                      NSLog(@"s2: %@",session);
                                      if (error != nil) {
                                          if (sender && requestErrorSelector) {
                                              SuppressPerformSelectorLeakWarning(
                                              [sender performSelector:requestErrorSelector withObject:error];
                                            );
                                          }
                                      } else {
                                          [self getUserDataForSender:sender handlingRequestSuccessSelector:requestSuccessSelector handlingRequestErrorSelector:requestErrorSelector];
                                      }
                                      
                                  }];
}

- (void)getUserDataForSender:(id)sender handlingRequestSuccessSelector:(SEL)requestSuccessSelector
   handlingRequestErrorSelector:(SEL)requestErrorSelector {
    [FBRequestConnection startWithGraphPath:@"me"
                          completionHandler:^(FBRequestConnection *connection,
                                              id <FBGraphUser> user,
                                              NSError *error) {
                              if (error != nil) {
                                  [error print];
                                  if (sender && requestErrorSelector) {
                                      SuppressPerformSelectorLeakWarning(
                                      [sender performSelector:requestErrorSelector withObject:error];
                                                                         );
                                  }
                              } else {
                                  NSLog(@"userInfo: %@", user);
                                  if (sender && requestSuccessSelector) {
                                      SuppressPerformSelectorLeakWarning(
                                      [sender performSelector:requestSuccessSelector withObject:user];
                                                                         );
                                  }
                              }
                              
                          }];
}

#pragma mark - post data to facebook


- (void)postDataWithLink:(NSString *)link
                 picture:(NSString *)picture
                    name:(NSString *)name
                 caption:(NSString *)caption
             description:(NSString *)description {

    //Validate and create FB share parameters
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"link"]               = (link) ? link : kDefultLink;
    dict[@"picture"]            = picture;
    dict[@"name"]               = name;
    dict[@"caption"]            = caption;
    dict[@"description"]        = description;
    [self shareWithParams:dict];
}


- (void)shareWithParams:(NSDictionary *)paramsd {
    
    if ([FBDialogs canPresentShareDialog]) {
        FBLinkShareParams *params = [FBLinkShareParams createWithParametrs:paramsd];
        [FBDialogs presentShareDialogWithParams:params
                                  clientState:nil
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              // An error occurred, we need to handle the error
                                              // See: https://developers.facebook.com/docs/ios/errors
                                              NSLog(@"Error publishing story: %@", error.description);
                                          } else {
                                              // Success
                                              NSLog(@"result %@", results);
                                          }
                                      }];

        
        // If the Facebook app is NOT installed and we can't present the share dialog
    } else {
        // FALLBACK: publish just a link using the Feed dialog
        // Show the feed dialog
        
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:paramsd
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          NSLog(@"Error publishing story: %@", error.description);
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
}

#pragma mark - additional functions

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




