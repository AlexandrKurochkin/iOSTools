//
//  TwitterManager.m
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

#import "TwitterManager.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "UIAlertView+Blocks.h"

@implementation TwitterManager

+ (id)sharedManager {
    static TwitterManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TwitterManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

+ (void)twitMessage:(NSString *)message {
    [[TwitterManager sharedManager] twitMessage:message];
}

- (void)twitMessage:(NSString *)message {
    NSString *post = message;
    
    if (post.length >= 141) {
        NSLog(@"Tweet won't be sent.");
    } else {
        ACAccountStore *accountStoreTw = [[ACAccountStore alloc] init];
        ACAccountType *accountTypeTw = [accountStoreTw accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        [accountStoreTw requestAccessToAccountsWithType:accountTypeTw options:NULL completion:
         
         
         ^(BOOL granted, NSError *error) {
            if(granted) {
                
                NSArray *accountsArray = [accountStoreTw accountsWithAccountType:accountTypeTw];
                
                if ([accountsArray count] > 0) {
                    ACAccount *twitterAccount = accountsArray[0];
                    
                    SLRequest* twitterRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                                   requestMethod:SLRequestMethodPOST
                                                                             URL:[NSURL URLWithString:@"https://api.twitter.com/1/statuses/update.json"]
                                                                      parameters:@{@"status": post}];
                    
                    [twitterRequest setAccount:twitterAccount];
                    
                    [twitterRequest performRequestWithHandler:^(NSData* responseData, NSHTTPURLResponse* urlResponse, NSError* error) {
                        NSLog(@"%@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
                        
                    }];
                    
                }
            }
            
        }];
    }
}

- (void)showErrorAllertForErrorCode:(NSNumber *)errorCode {
    NSInteger code = [errorCode integerValue];
    
    switch (code) {
        case 400:
            UIAlertViewShow(@"Twitter Error", @"Please login in twitter app", @[@"ok"], nil);
            break;
            
        default:
            UIAlertViewShow(@"Twitter Error", [NSString stringWithFormat: @"Error code %ld", (long)code], @[@"ok"], nil);
            break;
    }
}

+ (void)postImage:(UIImage *)image withStatus:(NSString *)status {
    if (image) {
        [[TwitterManager sharedManager] postImage:image withStatus:status];
    } else {
        [self twitMessage:status];
    }
}

- (void)postImage:(UIImage *)image withStatus:(NSString *)status {
    ACAccountStore *accountStoreTw = [[ACAccountStore alloc] init];
    ACAccountType *twitterType = [accountStoreTw accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    SLRequestHandler requestHandler =
    ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (responseData) {
            NSInteger statusCode = urlResponse.statusCode;

            NSString *alertText = nil;
            if (statusCode >= 200 && statusCode < 300) {
                NSDictionary *postResponseData =
                [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers
                                                  error:NULL];
                NSLog(@"[SUCCESS!] Created Tweet with ID: %@", postResponseData[@"id_str"]);
                alertText = @"Tweeted success";
            } else {
                [error print];
                alertText = [NSString stringWithFormat:@"[ERROR] Server responded: status code %ld %@", (long)statusCode,
                             [NSHTTPURLResponse localizedStringForStatusCode:statusCode]];
                NSLog(@"%@", alertText);
                
                [self performSelectorOnMainThread:@selector(showErrorAllertForErrorCode:) withObject:@(statusCode) waitUntilDone:NO];
                
            }

        }
        else {
            NSLog(@"[ERROR] An error occurred while posting: %@", [error localizedDescription]);
        }
    };
    
    ACAccountStoreRequestAccessCompletionHandler accountStoreHandler =
    ^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *accounts = [accountStoreTw accountsWithAccountType:twitterType];
            NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"
                          @"/1.1/statuses/update_with_media.json"];
            NSDictionary *params = @{@"status" : status};
            SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                    requestMethod:SLRequestMethodPOST
                                                              URL:url
                                                       parameters:params];
            if (image) {
                NSData *imageData = UIImageJPEGRepresentation(image, 1.f);
                [request addMultipartData:imageData
                                 withName:@"media[]"
                                     type:@"image/jpeg"
                                 filename:@"image.jpg"];
                
            }
            
            [request setAccount:[accounts lastObject]];
            [request performRequestWithHandler:requestHandler];
        }
        else {
            NSLog(@"[ERROR] An error occurred while asking for user authorization: %@",
                  [error localizedDescription]);
        }
    };
    
    [accountStoreTw requestAccessToAccountsWithType:twitterType
                                               options:NULL
                                            completion:accountStoreHandler];
}

@end
