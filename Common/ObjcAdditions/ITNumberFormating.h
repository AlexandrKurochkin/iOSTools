//
//  ITNumberFormating.h
//  WheninMerchant_ios
//
//  Created by Alex Kurochkin on 10/26/14.
//  Copyright (c) 2014 Alex Kurochkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITNumberFormating : NSObject

+ (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

+ (NSString*)formatNumber:(NSString*)mobileNumber;

@end
