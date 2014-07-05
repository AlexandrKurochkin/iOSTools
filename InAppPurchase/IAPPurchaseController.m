//
//  IAPPurchaseController.m
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


#import "IAPPurchaseController.h"
#import <objc/runtime.h>

NSString *const kSuccessPurchaseNotificationKey    = @"kSuccessPurchaseNotificationKey";
NSString *const kFailurePurchaseNotificationKey    = @"kFailurePurchaseNotificationKey";

NSString *const kSuccessPurchaseBlock           = @"kSuccessPurchaseBlock";
NSString *const kFailurePurchaseBlock           = @"kFailurePurchaseBlock";

@interface IAPPurchaseController () < SKPaymentTransactionObserver >

@property (nonatomic, unsafe_unretained, readwrite) SuccessPurchasedtBlock successPurchasedtBlock;
@property (nonatomic, unsafe_unretained, readwrite) FailurePurchasedBlock failurePurchasedBlock;

@end

@implementation IAPPurchaseController


#pragma properties

- (void)setSuccessPurchasedtBlock:(SuccessPurchasedtBlock)successPurchasedtBlock {
    objc_setAssociatedObject(self, &kSuccessPurchaseBlock, successPurchasedtBlock, OBJC_ASSOCIATION_COPY);
}

- (SuccessPurchasedtBlock)successPurchasedtBlock {
    return objc_getAssociatedObject(self, &kSuccessPurchaseBlock);
}

- (void)setFailurePurchasedBlock:(FailurePurchasedBlock)failurePurchasedBlock {
    objc_setAssociatedObject(self, &kFailurePurchaseBlock, failurePurchasedBlock, OBJC_ASSOCIATION_COPY);
}

- (FailurePurchasedBlock)failurePurchasedBlock {
    return objc_getAssociatedObject(self, &kFailurePurchaseBlock);
}


- (instancetype)init {
    self = [super init];
    if (self) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}



#pragma mark - Purchase Products

- (void)purchaseProduct:(SKProduct *)product quantity:(NSInteger)quantity
 successPurchaseHandler:(SuccessPurchasedtBlock)successPurchaseHandler
 failurePurchaseHandler:(FailurePurchasedBlock)failurePurchaseHandler {
    
    self.successPurchasedtBlock     = successPurchaseHandler;
    self.failurePurchasedBlock      = failurePurchaseHandler;
    
    [self sendProductToPurchase:product andQuantity:quantity];
}



- (void)sendProductToPurchase:(SKProduct *)product andQuantity:(NSInteger)quantity {
    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
    payment.quantity = quantity;
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}


#pragma mark - SKPaymentTransactionObserver

//Handling Transactions

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
                
            case SKPaymentTransactionStatePurchased:
                [self paymentTransactionStatePurchasedHandler:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self paymentTransactionStateFailedHandler:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self paymentTransactionStateRestored:transaction];
                break;
                
            case SKPaymentTransactionStatePurchasing:
                [self paymentTransactionStatePurchasing:transaction];
                break;
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions {
    TODO_NOT_IMPLEMENTED_YET
}


//Restored Transactions
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    TODO_NOT_IMPLEMENTED_YET
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    TODO_NOT_IMPLEMENTED_YET
}

//Handling Download Actions
- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads {
    TODO_NOT_IMPLEMENTED_YET
}

#pragma mark - Complite Transaction Handlers

- (void)paymentTransactionStatePurchasedHandler:(SKPaymentTransaction *)transaction {
    
    NSString *productIdetifier = transaction.payment.productIdentifier;
    if (self.successPurchasedtBlock)  {
        
        self.successPurchasedtBlock(productIdetifier);
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kSuccessPurchaseNotificationKey object:productIdetifier];
    }
    [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
}

- (void)paymentTransactionStateFailedHandler:(SKPaymentTransaction *)transaction {
    
    [transaction.error print];
    
    if (self.failurePurchasedBlock) {
        self.failurePurchasedBlock(transaction.error);
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kFailurePurchaseNotificationKey object:transaction.error];
    }
    
    if (transaction.error.code == 2) {
        [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
    }
}

- (void)paymentTransactionStateRestored:(SKPaymentTransaction *)transaction {
    TODO_NOT_IMPLEMENTED_YET
}

- (void)paymentTransactionStatePurchasing:(SKPaymentTransaction *)transaction {
    TODO_NOT_IMPLEMENTED_YET
}


@end
