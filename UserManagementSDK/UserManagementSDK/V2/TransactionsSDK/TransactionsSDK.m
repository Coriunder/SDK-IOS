//
//  TransactionsSDK.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods to perform requests to the Transactions service

#import "TransactionsSDK.h"
#import "TransactionRequestBuilder.h"
#import "TransactionsParser.h"

@implementation TransactionsSDK

static TransactionsSDK *_instance = nil;
static TransactionRequestBuilder *builder;
static TransactionsParser *parser;

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.serviceUrlPart = @"Transactions.svc";
        builder = [TransactionRequestBuilder new];
        parser = [TransactionsParser new];
    }
    return self;
}

+ (TransactionsSDK *)getInstance {
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [TransactionsSDK new];
        }
    }
    return _instance;
}

/************************************ REQUESTS SECTION START ************************************/

- (void)getTransactionWithId:(long)transactionId callback:(void (^)(BOOL success, Transaction *transaction, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForGet:transactionId];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"Get" callback:^(BOOL success, id resultObject) {
        if (success) {
            NSDictionary *result = [parser getDictionary:@"d" from:resultObject];
            if (result != nil) {
                // Parse response
                Transaction *transaction = [parser parseTransaction:result];
                if (callback) callback(YES, transaction, @"");
            } else {
                if (callback) callback(NO, nil, NSLocalizedStringFromTable(@"TransactionsNoItem", @"CoriunderStrings", @""));
            }
        } else {
            if (callback) callback(NO, nil, [parser parseError:resultObject]);
        }
    }];
}

- (void)lookupTransactionWithDate:(NSDate*)date amount:(double)amount last4cc:(NSString*)last4cc callback:(void (^)(BOOL success, NSMutableArray<TransactionLookup*> *result, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForLookup:date amount:amount last4cc:last4cc];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"Lookup" callback:^(BOOL success, id resultObject) {
        if (success) {
            // Parse response
            NSMutableArray *result = [parser parseTransactionLookup:resultObject];
            if (callback) callback(YES, result, @"");
        } else {
            if (callback) callback(NO, [NSMutableArray new], [parser parseError:resultObject]);
        }
    }];
}

- (void)processCartWithPinCode:(NSString*)pinCode addressId:(long)addressId cartCookie:(NSString*)cartCookie paymentMethodId:(long)paymentMethodId callback:(void (^)(BOOL success, ServiceResult *result, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForProcess:pinCode addressId:addressId
                                             cartCookie:cartCookie paymentMethodId:paymentMethodId];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"Process" callback:[parser createServiceCallbackWithUserCallback:callback]];
}

- (void)searchTransactionWithAmountFrom:(double)amountFrom amountTo:(double)amountTo currencyIso:(NSString*)currencyIso dateFrom:(NSDate*)dateFrom dateTo:(NSDate*)dateTo idFrom:(long)idFrom idTo:(long)idTo loadMerchant:(BOOL)loadMerchant loadPayer:(BOOL)loadPayer loadPayment:(BOOL)loadPayment transactionStatus:(int)transType page:(int)page pageSize:(int)pageSize callback:(void (^)(BOOL success, NSMutableArray<Transaction*> *result, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForSearch:amountFrom amountTo:amountTo currencyIso:currencyIso dateFrom:dateFrom dateTo:dateTo idFrom:idFrom idTo:idTo loadMerchant:loadMerchant loadPayer:loadPayer loadPayment:loadPayment transactionStatus:transType page:page pageSize:pageSize];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"Search" callback:^(BOOL success, id resultObject) {
        if (success) {
            // Parse response
            NSMutableArray *result = [parser parseSearch:resultObject];
            if (callback) callback(YES, result, @"");
        } else {
            if (callback) callback(NO, [NSMutableArray new], [parser parseError:resultObject]);
        }
    }];
}

/************************************* REQUESTS SECTION END *************************************/

@end
