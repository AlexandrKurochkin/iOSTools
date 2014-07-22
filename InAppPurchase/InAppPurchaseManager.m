//
//  InAppPurchaseManager.m
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


#import "InAppPurchaseManager.h"

@interface InAppPurchaseManager ()

@property (nonatomic, strong, readwrite) IAPProductsController *productsController;
@property (nonatomic, strong, readwrite) IAPPurchaseController *purchaseController;

@end

@implementation InAppPurchaseManager

@synthesize productsController, purchaseController;

+ (id)sharedManager {
    static InAppPurchaseManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[InAppPurchaseManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}


- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.productsController = [IAPProductsController new];
        self.purchaseController = [IAPPurchaseController new];
    }
    return self;
}

- (void)buyProductWithIdentifier:(NSString *)productIdentifier quantity:(NSInteger)quantity
                  successHandler:(SuccessResponse)successHandler failureHandler:(FailureResponse)failureHandler {
    
    [self.productsController fetchProduct:productIdentifier
                       withSuccessHandler:^(SKProduct *successProducts) {
                           DLog(@"");
                           [self.purchaseController purchaseProduct:successProducts
                                                           quantity:quantity
                                             successPurchaseHandler:successHandler
                                             failurePurchaseHandler:failureHandler];
                           
                       } failureHandeler:failureHandler];
}

@end