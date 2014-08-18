//
//  AlertManager.h
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

#import <Foundation/Foundation.h>

#define kWarning            @"Warning"
#define kErrorTitle         @"Error"
#define kOkButton           @"Ok"

//Common messages
#define kNoInternetMessage                  @"No internet connection. Please try later"
#define kWrongLengthMessage                 @"Length of %@ should be more than %ld"
#define kEmailValidatiomMessage             @"Wrong email."
#define kPhoneValidatiomMessage             @"Wrong phone number."

//User data messages
#define kBirthdayValidationMessage          @"Wrong date of birth. You must be at least %d years old."
#define kRadiusValidatiomMessage            @"Radius should contain only digital and should be more than 0"

//Password messages
#define kWrongPswdMessage                   @"Wrong Password."
#define kNewPswdNoMatxgMessage              @"New password doesn't match."
#define kNewPswdSmallLenghtMessage          @"Length of password should be 6 and more characters."
#define kNewCurrentPswdVoidMessage          @"Current password is void."
#define kNewPswdChangedSuccessMessage       @"Password changed successfully."

//This part in development
#define kThisPartInDevelopment              @"Sorry. This part is in the development"



@interface AlertManager : NSObject

+ (void)showSimpleAlertWithTitle:(NSString *)title
                         message:(NSString *)message
               cancelButtonTitle:(NSString *)cancelButtonTitle;


/*========= Common App Alerts =========*/
+ (void)showAllertForError:(NSError *)error;
+ (void)showAllertAboutNoInternetConnection;
+ (void)showAllertAboutWrongLengthOf:(NSString *)fieldName minLenght:(NSUInteger)minLenght;
+ (void)showAllertAboutWrongEmail;
+ (void)showAllertAboutWrongPhoneNumber;

/*========= User data alerts =========*/
+ (void)showAllertAboutWrongRadius;
+ (void)showAllertAboutWrongBirthday;

/*==== Password alerts =======*/
+ (void)showAllertAboutWrongPassword;
+ (void)showAllertAboutNewPasswortNoMatch;
+ (void)showAllertAboutSmallPswdLength;
+ (void)showAllertAboutVoidCurrentPswd;
+ (void)showAllertAboutSuccessChangedPswd;

//This part in development

+(void)showAllertAboutDevelopmentPart;




@end
