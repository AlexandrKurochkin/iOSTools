//
//  ITGooglePlusManager.m
//  WheninMerchant_ios
//
//  Created by Alex Kurochkin on 1/9/15.
//  Copyright (c) 2015 Alex Kurochkin. All rights reserved.
//

#import "ITGooglePlusManager.h"
#import <GooglePlus/GooglePlus.h>

@interface ITGooglePlusManager () < GPPSignInDelegate, GPPShareDelegate >

@property (nonatomic, strong, readwrite) NSString *title;
@property (nonatomic, strong, readwrite) NSString *descriptionGP;
@property (nonatomic, strong, readwrite) NSURL *thumbnailURL;
@property (nonatomic, strong, readwrite) NSString *prefillText;
@property (nonatomic, strong, readwrite) NSURL *URLToShare;

@end

@implementation ITGooglePlusManager

@synthesize title;
@synthesize descriptionGP;
@synthesize thumbnailURL;
@synthesize prefillText;
@synthesize URLToShare;

+ (id)sharedManager {
    static ITGooglePlusManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ITGooglePlusManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (void)postDataWithTitle:(NSString *)aTitle
              description:(NSString *)description
             thumbnailURL:(NSURL *)aThumbnailURL
              prefillText:(NSString *)aPrefillText
               URLToShare:(NSURL *)anURLToShare {
    
    self.title          = title;
    self.descriptionGP  = description;
    self.thumbnailURL   = aThumbnailURL;
    
    self.prefillText    = aPrefillText;
    self.URLToShare     = anURLToShare;
    
    [self doSighIn];
}


- (BOOL)doShare {
    
    GPPShare* plusShare = [GPPShare sharedInstance];
    
    if (plusShare.delegate != self) {
        plusShare.delegate = self;
    }

    
    // Or use the basic share, which does not require using Google+ Sign-In:
    id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
    
    
    
    // Set any prefilled text that you might want to suggest
    [shareBuilder setPrefillText:self.prefillText];
    
    [shareBuilder setURLToShare:self.URLToShare];
    
    [shareBuilder setTitle:self.title description:self.descriptionGP thumbnailURL:self.thumbnailURL];
    
    [shareBuilder setContentDeepLinkID:@"/albums/sf/1234567"];
    
    return [shareBuilder open];
    
}

- (void)doSighIn {
    GPPSignIn* plusSignIn = [GPPSignIn sharedInstance];
    
    if (plusSignIn.delegate != self) {
        // register
        plusSignIn.delegate = self;
    }
    [plusSignIn authenticate];
}


#pragma mark - GPPSignInDelegate


- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error {
    
    if (!error) {
        // we can share now. this will call the GPPShareDelegate methods.
        if (![self doShare]) {
            NSLog(@"GPPShareActivity error: cannot open share dialog");
        }
    } else {
        NSLog(@"GPPShareActivity authentication failure: %@", error.localizedDescription);
        
    }
}

- (void)didDisconnectWithError:(NSError *)error {
    NSLog(@"GPPShareActivity disconnected: %@", error.localizedDescription);
}

#pragma mark - GPPShareDelegate


- (void)finishedSharingWithError:(NSError *)error {

    if (error) {
        NSLog(@"GPPShareActivity sharing failure: %@", error.localizedDescription);
    }
    
}



@end
