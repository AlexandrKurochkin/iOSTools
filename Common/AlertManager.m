//
//  AlertManager.m
//  WheniniOS
//
//  Created by Alex Kurochkin on 7/18/13.
//  Copyright (c) 2013 Alex Kurochkin. All rights reserved.
//

#import "AlertManager.h"

@implementation AlertManager

+ (void)showSimpleAlertWithTitle:(NSString *)title
                         message:(NSString *)message
                    cancelButtonTitle:(NSString *)cancelButtonTitle {
    [[[UIAlertView alloc] initWithTitle:title
                                 message:message
                                delegate:nil
                       cancelButtonTitle:cancelButtonTitle
                       otherButtonTitles:nil] show];
}

+ (void)showAllertForError:(NSError *)error {
    if (error.code == -1009) {
        [AlertManager
         showAllertAboutNoInternetConnection];
    } else {
//        NSString *debugErrorMsg = [NSString stringWithFormat:@"code: %d %@", error.code, error.domain];
        NSString *errorMsg = [NSString stringWithFormat:@"%@", error.domain];
        [AlertManager showSimpleAlertWithTitle:kErrorTitle message:errorMsg cancelButtonTitle:kOkButton];
    }
}

+ (void)showAllertAboutNoInternetConnection {
    [AlertManager showSimpleAlertWithTitle:kErrorTitle message:kNoInternetMessage cancelButtonTitle:kOkButton];
}

+ (void)showAllertAboutWrongLength {
    [AlertManager showSimpleAlertWithTitle:kErrorTitle message:kWrongLengthMessage cancelButtonTitle:kOkButton];
}


#pragma mark - Preferences messages

+ (void)showAllertAboutWrongRadius {
    [AlertManager showSimpleAlertWithTitle:kErrorTitle message:kRadiusValidatiomMessage cancelButtonTitle:kOkButton];
}

+ (void)showAllertAboutWrongEmail {
    [AlertManager showSimpleAlertWithTitle:kErrorTitle message:kEmailValidatiomMessage cancelButtonTitle:kOkButton];
}

+ (void)showAllertAboutWrongBirthday {
    [AlertManager showSimpleAlertWithTitle:kErrorTitle message:[NSString stringWithFormat:kBirthdayValidationMessage, WHValidAge] cancelButtonTitle:kOkButton];
}


#pragma mark - Change passwords messages

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
    [AlertManager showSimpleAlertWithTitle:kWheninTitle message:kNewPswdChangedSuccessMessage cancelButtonTitle:kOkButton];
}



@end
