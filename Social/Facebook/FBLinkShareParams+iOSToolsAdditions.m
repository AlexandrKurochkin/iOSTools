//
//  FBLinkShareParams+iOSToolsAdditions.m
//  WheninMerchant_ios
//
//  Created by Alex Kurochkin on 8/1/14.
//  Copyright (c) 2014 Alex Kurochkin. All rights reserved.
//

#import "FBLinkShareParams+iOSToolsAdditions.h"

@implementation FBLinkShareParams (iOSToolsAdditions)

+ (instancetype)createWithParametrs:(NSDictionary *)parametrs {
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    
    params.name             = parametrs[@"name"];
    params.linkDescription  = parametrs[@"description"];
    params.caption          = parametrs[@"caption"];
    params.link             = [parametrs[@"link"] httpSchemeLink];
    params.picture          = [parametrs[@"picture"] httpSchemeLink];
    
    return params;
    
}

- (NSDictionary *)dictionary {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (self.link)          [dict setObject:self.link forKey:@"link"];
    if (self.picture)       [dict setObject:self.picture forKey:@"picture"];
    if (self.name)          [dict setObject:self.name forKey:@"name"];
    if (self.caption)       [dict setObject:self.caption forKey:@"caption"];
    if (self.linkDescription)   [dict setObject:self.linkDescription forKey:@"description"];
    
    
    return [NSDictionary dictionaryWithDictionary:dict];
    //    return @{@"name":self.name, @"link":self.link, @"picture":self.picture, @"caption":self.caption, @"description":self.description};
}

@end
