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

@implementation TwitterManager

+ (void)twitMessage:(NSString *)message {
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

+ (void)postImage:(UIImage *)image withStatus:(NSString *)status {
    ACAccountStore *accountStoreTw = [[[ACAccountStore alloc] init] autorelease];
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
            }
            else {
                alertText = [NSString stringWithFormat:@"[ERROR] Server responded: status code %d %@", statusCode,
                             [NSHTTPURLResponse localizedStringForStatusCode:statusCode]];
                NSLog(@"%@", alertText);
            }
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tweet result"
//                                         message:alertText
//                                        delegate:self
//                               cancelButtonTitle:@"OK!"
//                               otherButtonTitles:nil];
//            
//            [alert show];
//            [alert release];
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
