//
//  AlertManager.m
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

#import "AlertManager.h"

#define kNoPreviusTime 0

@interface AlertManager ()

@property (nonatomic, strong, readwrite) NSString *previusMessage;
@property (nonatomic, unsafe_unretained, readwrite) NSTimeInterval previusMessageTime;


@end

@implementation AlertManager

@synthesize previusMessage, previusMessageTime;

+ (instancetype)sharedInstance {
    static AlertManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [AlertManager new];
        sharedInstance.previusMessageTime = kNoPreviusTime;
    });
    return sharedInstance;
}

- (BOOL)isShouldShowAlertWithMessage:(NSString *)message {
    BOOL returnValue = YES;

    
    NSTimeInterval currentTimeInterval = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval difTimeInterval = currentTimeInterval  - self.previusMessageTime;
    NSLog(@"difTimeInterval: %lf", difTimeInterval);
    
    if ([self.previusMessage isEqualToString:message] && difTimeInterval < 2) {
        returnValue = NO;
    }
    
    self.previusMessage     = message;
    self.previusMessageTime = currentTimeInterval;
    
    return returnValue;
}

- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
         cancelButtonTitle:(NSString *)cancelButtonTitle {
    
    
    if ([self isShouldShowAlertWithMessage:message]) {
        [[[UIAlertView alloc] initWithTitle:title
                                    message:message
                                   delegate:nil
                          cancelButtonTitle:cancelButtonTitle
                          otherButtonTitles:nil] show];

    }
    
}



+ (void)showSimpleAlertWithTitle:(NSString *)title
                         message:(NSString *)message
                    cancelButtonTitle:(NSString *)cancelButtonTitle {
    
    [[AlertManager sharedInstance] showAlertWithTitle:title
                                              message:message
                                    cancelButtonTitle:cancelButtonTitle];
    
//    [[[UIAlertView alloc] initWithTitle:title
//                                 message:message
//                                delegate:nil
//                       cancelButtonTitle:cancelButtonTitle
//                       otherButtonTitles:nil] show];
}

+ (void)showAllertForError:(NSError *)error {
    if (
        (error.code == -1009) ||
        (error.code == 306 && [error.domain isEqualToString:(__bridge NSString *)kCFErrorDomainCFNetwork])
        ) {
        [AlertManager showAllertAboutNoInternetConnection];
    } else {
//        NSString *debugErrorMsg = [NSString stringWithFormat:@"code: %d %@", error.code, error.domain];
//        NSString *errorMsg = [NSString stringWithFormat:@"%@", error.domain];
//        NSString *errorMsg = [NSString stringWithFormat:@"%@. %@.", error.domain, error.localizedDescription];
        
        
        
        [AlertManager showSimpleAlertWithTitle:error.domain message:error.localizedDescription cancelButtonTitle:kOkButton];
    }
}

+ (void)showAllertAboutNoInternetConnection {
    [AlertManager showSimpleAlertWithTitle:kErrorTitle message:kNoInternetMessage cancelButtonTitle:kOkButton];
}

+ (void)showAllertAboutWrongLengthOf:(NSString *)fieldName minLenght:(NSUInteger)minLenght {
    NSString *msg = [NSString stringWithFormat:kWrongLengthMessage, fieldName, (unsigned long)minLenght];
    [AlertManager showSimpleAlertWithTitle:kErrorTitle message:msg cancelButtonTitle:kOkButton];
}

+ (void)showAlertAboutEmptyEmail {
    [AlertManager showSimpleAlertWithTitle:kWarning
                                   message:kEmptyEmailMessage
                         cancelButtonTitle:kOkButton];
}

+ (void)showAllertAboutNotConfigureMailSettings {
    [AlertManager showSimpleAlertWithTitle:kAppTitle message:kNoMailConfiguration cancelButtonTitle:kOkButton];
}

#pragma mark - Preferences messages

+ (void)showAllertAboutWrongRadius {
    [AlertManager showSimpleAlertWithTitle:kErrorTitle message:kRadiusValidatiomMessage cancelButtonTitle:kOkButton];
}

+ (void)showAllertAboutWrongEmail {
    [AlertManager showSimpleAlertWithTitle:kErrorTitle message:kEmailValidatiomMessage cancelButtonTitle:kOkButton];
}

+ (void)showAllertAboutWrongPhoneNumber {
    [AlertManager showSimpleAlertWithTitle:kErrorTitle message:kPhoneValidatiomMessage cancelButtonTitle:kOkButton];
}

+ (void)showAllertAboutWrongBirthday {
    [AlertManager showSimpleAlertWithTitle:kErrorTitle message:[NSString stringWithFormat:kBirthdayValidationMessage, WHValidAge] cancelButtonTitle:kOkButton];
}


#pragma mark - Change passwords messages

+ (void)showAllertAboutWrongPassword {
    [AlertManager showSimpleAlertWithTitle:kErrorTitle message:kWrongPswdMessage cancelButtonTitle:kOkButton];
}

+ (void)showAllertAboutNewPasswortNoMatch {
    [AlertManager showSimpleAlertWithTitle:kErrorTitle message:kNewPswdNoMatxgMessage cancelButtonTitle:kOkButton];
}

+ (void)showAllertAboutSmallPswdLength {
    [AlertManager showSimpleAlertWithTitle:kErrorTitle message:kNewPswdSmallLenghtMessage cancelButtonTitle:kOkButton];
}

+ (void)showAllertAboutVoidCurrentPswd {
    [AlertManager showSimpleAlertWithTitle:kErrorTitle message:kNewCurrentPswdVoidMessage cancelButtonTitle:kOkButton];
}

+ (void)showAllertAboutSuccessChangedPswd {
    [AlertManager showSimpleAlertWithTitle:kAppTitle message:kNewPswdChangedSuccessMessage cancelButtonTitle:kOkButton];
}

+ (void)showAllertAboutDevelopmentPart {
    [AlertManager showSimpleAlertWithTitle:kWarning
                                   message:kThisPartInDevelopment
                         cancelButtonTitle:kOkButton];
    
}

+ (void)showAlertAboutReauiredValue:(NSString *)valueName {
    
    [AlertManager showSimpleAlertWithTitle:kAppTitle
                                   message:[NSString stringWithFormat:kValueIsRequiredAndCannotBeEmpty, valueName]
                         cancelButtonTitle:kOkButton];
}

+ (void)showMaxValAlert:(NSInteger)_maxValOfTime {
    [AlertManager showSimpleAlertWithTitle:kAppTitle
                                   message:[NSString stringWithFormat:@"%@ %ld", kMaxValueOfTime, (long)_maxValOfTime]
                         cancelButtonTitle:kOkButton];
}

@end
