//
//  ShopSDKCarts.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods to perform requests to the Shop service related to carts

#import "ShopSDKCarts.h"
#import "ShopRequestBuilder.h"
#import "ShopParser.h"

@implementation ShopSDKCarts

static ShopSDKCarts *_instance = nil;
static ShopRequestBuilder *builder;
static ShopParser *parser;

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.serviceUrlPart = @"Shop.svc";
        builder = [ShopRequestBuilder new];
        parser = [ShopParser new];
    }
    return self;
}

+ (ShopSDKCarts *)getInstance {
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [ShopSDKCarts new];
        }
    }
    return _instance;
}

/************************************ REQUESTS SECTION START ************************************/

- (Cart*)createNewCartForMerchant:(NSString*)merchantId currencyIso:(NSString*)currencyIso {
    return [[Cart alloc] initWithCurrencyIso:currencyIso merchantNumber:merchantId];
}

- (void)getActiveCarts:(void (^)(BOOL success, NSMutableArray<Cart*> *carts, NSString* message))callback {
    
    // Create request
    [self sendPostRequestWithParameters:nil withMethod:@"GetActiveCarts" callback:^(BOOL success, id resultObject) {
        if (success) {
            // Parse response
            NSMutableArray *carts = [parser parseActiveCarts:resultObject];
            if (callback) callback(YES, carts, @"");
        } else {
            if (callback) callback(NO, [NSMutableArray new], [parser parseError:resultObject]);
        }
    }];
}

- (void)getCartWithCookie:(NSString*)cookie callback:(void (^)(BOOL success, Cart* cart, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForGetCart:cookie];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"GetCart" callback:[self createCartCallbackWithUserCallback:callback]];
}

- (void)getCartOfTransaction:(long)transactionId callback:(void (^)(BOOL success, Cart* cart, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForGetCartOfTransaction:transactionId];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"GetCartOfTransaction" callback:[self createCartCallbackWithUserCallback:callback]];
}

- (void)updateCart:(Cart*)cart callback:(void (^)(BOOL success, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForUpdateCart:cart];
    if (params == nil) {
        if (callback) callback(NO, NSLocalizedStringFromTable(@"ErrorCreatingRequest", @"CoriunderStrings", @""));
        return;
    }    
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"SetCart" callback:^(BOOL success, id resultObject) {
        if (success) {
            // Parse response
            NSString *obj =[parser getString:@"d" from:resultObject];
            if (obj.length > 0) {
                if (callback) callback(YES, obj);
            } else {
                if (callback) callback(NO, NSLocalizedStringFromTable(@"ShopErrorNoCart", @"CoriunderStrings", @""));
            }
        } else {
            if (callback) callback(NO, [parser parseError:resultObject]);
        }
    }];
}

/************************************* REQUESTS SECTION END *************************************/

/**
 * @param callback callback to be called on request result
 * @return listener which parses result to Cart object and calls the callback
 */
- (void (^)(BOOL success, id resultObject))createCartCallbackWithUserCallback:(void (^)(BOOL success, Cart* cart, NSString *message))callback {
    
    return ^(BOOL success, id resultObject) {
        if (success) {
            NSDictionary *cartDict = [parser getDictionary:@"d" from:resultObject];
            if (cartDict != nil) {
                // Parse cart
                Cart *cart = [parser parseCart:cartDict];
                if (callback) callback(YES, cart, @"");
            } else {
                if (callback) callback(NO, nil, NSLocalizedStringFromTable(@"ShopErrorNoCart", @"CoriunderStrings", @""));
            }
        } else {
            if (callback) callback(NO, nil, [parser parseError:resultObject]);
        }
    };
}

@end
