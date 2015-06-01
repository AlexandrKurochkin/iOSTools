//
//  UILabel+Additions.m
//  WheninMerchant_ios
//
//  Created by Alex Kurochkin on 12/14/14.
//  Copyright (c) 2014 Alex Kurochkin. All rights reserved.
//

#import "UILabel+Additions.h"

@implementation UILabel (Additions)

- (void)setupIOS8StringForLabel:(NSString *)aString {
    self.text = (aString.length > 0) ? aString : @"    ";
}

@end
