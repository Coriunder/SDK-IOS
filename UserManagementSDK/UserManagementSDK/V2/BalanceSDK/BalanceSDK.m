//
//  BalanceSDK.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods to perform requests to the Balance service

#import "BalanceSDK.h"
#import "BalanceRequestBuilder.h"
#import "BalanceParser.h"

@implementation BalanceSDK

static BalanceSDK *_instance = nil;
static BalanceRequestBuilder *builder;
static BalanceParser *parser;

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.serviceUrlPart = @"Balance.svc";
        builder = [BalanceRequestBuilder new];
        parser = [BalanceParser new];
    }
    return self;
}

+ (BalanceSDK *)getInstance {
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [BalanceSDK new];
        }
    }
    return _instance;
}

/************************************ REQUESTS SECTION START ************************************/

- (void)getRequestWithId:(long)requestId callback:(void (^)(BOOL success, Request *request, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForGetRequest:requestId];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"GetRequest" callback:^(BOOL success, id resultObject) {
        if (success) {
            NSDictionary *result = [parser getDictionary:@"d" from:resultObject];
            if (result != nil) {
                // Parse response
                Request *item = [parser parseRequest:result];
                if (callback) callback(YES, item, @"");
            } else  {
                if (callback) callback(NO, nil, NSLocalizedStringFromTable(@"BalanceNoItem", @"CoriunderStrings", @""));
            }
        } else {
            if (callback) callback(NO, nil, [parser parseError:resultObject]);
        }
    }];
}

- (void)getRequestsWithCurrency:(NSString*)currencyIso paymentMethodId:(long)paymentMethodId page:(int)page pageSize:(int)pageSize callback:(void (^)(BOOL success, NSMutableArray<Request*> *requests, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForGetRequests:currencyIso paymentMethodId:paymentMethodId page:page pageSize:pageSize];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"GetRequests" callback:^(BOOL success, id resultObject) {
        if (success) {
            // Parse response
            NSMutableArray *array = [parser parseRequests:resultObject];
            if (callback) callback(YES, array, @"");
        } else {
            if (callback) callback(NO, [NSMutableArray new], [parser parseError:resultObject]);
        }
    }];
}

- (void)getTransactionsHistoryWithCurrency:(NSString*)currencyIso paymentMethodId:(long)paymentMethodId page:(int)page pageSize:(int)pageSize callback:(void (^)(BOOL success, NSMutableArray<BalanceRow*> *balanceRows, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForGetRows:currencyIso paymentMethodId:paymentMethodId page:page pageSize:pageSize];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"GetRows" callback:^(BOOL success, id resultObject) {
        if (success) {
            // Parse response
            NSMutableArray *array = [parser parseRows:resultObject];
            if (callback) callback(YES, array, @"");
        } else {
            if (callback) callback(NO, [NSMutableArray new], [parser parseError:resultObject]);
        }
    }];
    
}

- (void)getTotalForCurrency:(NSString*)currencyIso callback:(void (^)(BOOL success, NSMutableArray<BalanceTotal*> *balances, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForGetTotal:currencyIso];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"GetTotal" callback:^(BOOL success, id resultObject) {
        if (success) {
            // Parse response
            NSMutableArray *array = [parser parseTotal:resultObject];
            if (callback) callback(YES, array, @"");
        } else {
            if (callback) callback(NO, [NSMutableArray new], [parser parseError:resultObject]);
        }
    }];
}

- (void)replyRequest:(long)requestId approve:(BOOL)approve pinCode:(NSString*)pinCode text:(NSString*)text callback:(void (^)(BOOL success, ServiceResult *result, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForReplyRequest:requestId approve:approve pinCode:pinCode text:text];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"ReplyRequest" callback:[parser createServiceCallbackWithUserCallback:callback]];
}

- (void)requestAmountFromUser:(NSString*)userId amount:(double)amount currencyIso:(NSString*)currencyIso text:(NSString*)text callback:(void (^)(BOOL success, ServiceResult *result, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForRequestAmount:userId amount:amount currencyIso:currencyIso text:text];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"RequestAmount" callback:[parser createServiceCallbackWithUserCallback:callback]];
}

- (void)transferAmountToUser:(NSString*)userId amount:(double)amount currencyIso:(NSString*)currencyIso pinCode:(NSString*)pinCode text:(NSString*)text callback:(void (^)(BOOL success, ServiceResult *result, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForTransferAmount:userId amount:amount currencyIso:currencyIso pinCode:pinCode text:text];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"TransferAmount" callback:[parser createServiceCallbackWithUserCallback:callback]];
}

/************************************* REQUESTS SECTION END *************************************/

@end
