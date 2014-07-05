//
//  IAPProductsController.m
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


#import "IAPProductsController.h"
#import <objc/runtime.h>

NSString *const kResponseFailureText        = @"Problem product with product Identifier %@";

NSString *const kResponseBlock              = @"kResponseBlock";
NSString *const kSuccessProductBlock        = @"kSuccessProductBlock";
NSString *const kFailureProductBlock        = @"kFailureProductBlock";

@interface IAPProductsController () <SKProductsRequestDelegate>

@property (nonatomic, strong, readwrite) SKProductsRequest *productsRequest;
@property (nonatomic, unsafe_unretained, readwrite) ProductsResponse productsResponseBlock;

@property (nonatomic, unsafe_unretained, readwrite) SuccessProductBlock successProductBlock;
@property (nonatomic, unsafe_unretained, readwrite) FailureProductBlock failureProductBlock;

@end

@implementation IAPProductsController

@synthesize productsRequest;


#pragma mark - properties

- (void)setProductsResponseBlock:(ProductsResponse)block {
	objc_setAssociatedObject(self, &kResponseBlock, block, OBJC_ASSOCIATION_COPY);
}

- (ProductsResponse)productsResponseBlock {
	return objc_getAssociatedObject(self, &kResponseBlock);
}



- (void)setSuccessProductBlock:(SuccessProductBlock)successProductBlock {
	objc_setAssociatedObject(self, &kSuccessProductBlock, successProductBlock, OBJC_ASSOCIATION_COPY);
}

- (SuccessProductBlock)successProductBlock {
	return objc_getAssociatedObject(self, &kSuccessProductBlock);
}

- (void)setFailureProductBlock:(FailureProductBlock)failureProductBlock {
    objc_setAssociatedObject(self, &kFailureProductBlock, failureProductBlock, OBJC_ASSOCIATION_COPY);
}

- (FailureProductBlock)failureProductBlock {
    return objc_getAssociatedObject(self, &kFailureProductBlock);
}

#pragma mark - fetchProducts

- (void)fetchProducts:(NSArray *)products withResponseHandler:(ProductsResponse)responseHandler {
    
    self.productsResponseBlock = responseHandler;
    self.successProductBlock = nil;
    self.failureProductBlock = nil;
    
    [self runProductRequest:[[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:products]]];
}

- (void)fetchProduct:(NSString *)productName withSuccessHandler:(SuccessProductBlock)successHandler failureHandeler:(FailureProductBlock)failureHandeler {
    
    self.productsResponseBlock = nil;
    self.successProductBlock = successHandler;
    self.failureProductBlock = failureHandeler;
    
    [self runProductRequest:[[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:@[productName]]]];
}


- (void)runProductRequest:(SKProductsRequest *)productRequest {
    self.productsRequest = productRequest;
    self.productsRequest.delegate = self;
    [self.productsRequest start];
}

#pragma mark - SKProductsRequestDelegate protocol method

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    [self printProductResponse:response];
    
    if (self.productsResponseBlock) {
        self.productsResponseBlock(response.products, response.invalidProductIdentifiers);
    } else {
        SKProduct *product = [response.products lastObject];
        if (product) {
            self.successProductBlock(product);
        } else {
            NSError *error = [NSError errorWithDomain:[NSString stringWithFormat:kResponseFailureText, response.invalidProductIdentifiers[0]] code:1 userInfo:nil];
            self.failureProductBlock(error);
        }
    }
}

- (void)printProductResponse:(SKProductsResponse *)response {
    NSArray *products = response.products;
    DLog(@"products: %@", products);
    
    for (NSString *invalidIdentifier in response.invalidProductIdentifiers) {
        DLog(@"invalidIdentifier: %@", invalidIdentifier);
    }
}

@end
