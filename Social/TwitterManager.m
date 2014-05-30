//
//  TwitterManager.m
//  WheniniOS
//
//  Created by Alex Kurochkin on 7/16/13.
//  Copyright (c) 2013 Alex Kurochkin. All rights reserved.
//

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
        [accountStoreTw requestAccessToAccountsWithType:accountTypeTw options:NULL completion:^(BOOL granted, NSError *error) {
            if(granted) {
                
                NSArray *accountsArray = [accountStoreTw accountsWithAccountType:accountTypeTw];
                
                if ([accountsArray count] > 0) {
                    ACAccount *twitterAccount = accountsArray[0];
                    
                    SLRequest* twitterRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                                   requestMethod:SLRequestMethodPOST
                                                                             URL:[NSURL URLWithString:@"http://api.twitter.com/1/statuses/update.json"]
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
            UIAlertViewShow(@"Twitter Error", [NSString stringWithFormat: @"Error code %d", code], @[@"ok"], nil);
            break;
    }
}

+ (void)postImage:(UIImage *)image withStatus:(NSString *)status {
    [[TwitterManager sharedManager] postImage:image withStatus:status];
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
