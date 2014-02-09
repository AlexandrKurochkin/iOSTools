//
//  FacebookManager.m
//  WheniniOS
//
//  Created by Alex Kurochkin on 7/12/13.
//  Copyright (c) 2013 Alex Kurochkin. All rights reserved.
//

#import "FacebookManager.h"

@interface FacebookManager ()

@property (nonatomic, retain, readwrite) NSDictionary *parametrs;

@end

@implementation FacebookManager

@synthesize parametrs;

static FacebookManager *sharedInstance = nil;

+ (instancetype)sharedManager {
	if (sharedInstance == nil) {
		sharedInstance = [[self alloc] init];
	}
	return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
//        self.session = [[[FBSession alloc] init]autorelease];
//        [FBSession setActiveSession:self.session];
        
//        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info", @"email", @"user_birthday"]
//                                           allowLoginUI:YES
//                                      completionHandler:^(FBSession *session,
//                                                          FBSessionState status,
//                                                          NSError *error) {
////                                          
////                                          if (error != nil) {
////                                              if (sender && requestErrorSelector) {
////                                                  [sender performSelector:requestErrorSelector withObject:error];
////                                              }
////                                          } else {
////                                              [self getUserDataForSender:sender handlingRequestSuccessSelector:requestSuccessSelector handlingRequestErrorSelector:requestErrorSelector];
////                                          }
//                                          
//                                      }];
    }
    return self;
}

- (void)dealloc {
    self.parametrs = nil;
    self.session = nil;
}

#pragma mark - Facebook life cicle

- (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication {
//    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:self.session];
    return  [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

- (void)appWillTerminate {
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (void)appDidBecomeActive {
//    [FBAppCall handleDidBecomeActiveWithSession:self.session];
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
    // Ask for publish_actions permissions in context
   self.parametrs = @{
      @"link" : link,
      @"picture" : picture,
      @"name" : name,
      @"caption" : caption,
      @"description" : description
      };
    
    [[FBSession activeSession] closeAndClearTokenInformation];
//    if ([FBSession.activeSession.permissions
//         indexOfObject:@"publish_actions"] == NSNotFound) {
        // Permission hasn't been granted, so ask for publish_actions
        [FBSession openActiveSessionWithPublishPermissions:@[@"publish_actions"]
                                           defaultAudience:FBSessionDefaultAudienceFriends
                                              allowLoginUI:YES
                                         completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                             if (FBSession.activeSession.isOpen && !error) {
                                                 // Publish the story if permission was granted
                                                 [self publishStory:self.parametrs];
                                             }
                                         }];
//    } else {
//        [self publishStory: self.parametrs];
//    }
}

- (void)publishStory:(NSDictionary *)parameters  {
    [FBRequestConnection
     startWithGraphPath:@"me/feed"
     parameters:parameters
     HTTPMethod:@"POST"
     completionHandler:^(FBRequestConnection *connection,
                         id result,
                         NSError *error) {
         NSString *alertText;
         if (error) {
             alertText = [NSString stringWithFormat:
                          @"error: domain = %@, code = %d",
                          error.domain, error.code];
         } else {
             alertText = @"Success";
             NSLog(@"Posted action, id: %@",
                   result[@"id"]);
         }
         DLog(@"%@", alertText);
         // Show the result in an alert
//         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook result"
//                                     message:alertText
//                                    delegate:self
//                           cancelButtonTitle:@"OK!"
//                           otherButtonTitles:nil];
//         [alert show];
//         [alert release];
     }];
}


@end
