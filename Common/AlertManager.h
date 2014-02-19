//
//  AlertManager.h
//  WheniniOS
//
//  Created by Alex Kurochkin on 7/18/13.
//  Copyright (c) 2013 Alex Kurochkin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kErrorTitle         @"Error"
#define kOkButton           @"Ok"

//Common messages
#define kNoInternetMessage                  @"No internet connection. Please try later"
#define kWrongLengthMessage                 @"Lenght of name should be more then 0"
#define kEmailValidatiomMessage             @"Wrong email."

//User data messages
#define kBirthdayValidationMessage          @"Wrong date of birth. You must be at least %d years old."
#define WHValidAge       4
#define kRadiusValidatiomMessage            @"Radius should contain only digital and should be more then 0"

//Password messages
#define kNewPswdNoMatxgMessage              @"New password doesn't match."
#define kNewPswdSmallLenghtMessage          @"Length of password should be 6 and more characters."
#define kNewCurrentPswdVoidMessage          @"Current password is void."
#define kNewPswdChangedSuccessMessage       @"Password changed successfully."


@interface AlertManager : NSObject

+ (void)showSimpleAlertWithTitle:(NSString *)title
                         message:(NSString *)message
               cancelButtonTitle:(NSString *)cancelButtonTitle;


/*========= Common App Alerts =========*/
+ (void)showAllertForError:(NSError *)error;
+ (void)showAllertAboutNoInternetConnection;
+ (void)showAllertAboutWrongLength;
+ (void)showAllertAboutWrongEmail;

/*========= User data alerts =========*/
+ (void)showAllertAboutWrongRadius;
+ (void)showAllertAboutWrongBirthday;

/*==== Password alerts =======*/
+ (void)showAllertAboutNewPasswortNoMatch;
+ (void)showAllertAboutSmallPswdLength;
+ (void)showAllertAboutVoidCurrentPswd;
+ (void)showAllertAboutSuccessChangedPswd;




@end
