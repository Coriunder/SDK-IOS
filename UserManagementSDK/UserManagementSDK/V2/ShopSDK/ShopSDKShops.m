//
//  ShopSDKShops.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods to perform requests to the Shop service related to shops

#import "ShopSDKShops.h"
#import "ShopRequestBuilder.h"
#import "ShopParser.h"

@implementation ShopSDKShops

static ShopSDKShops *_instance = nil;
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

+ (ShopSDKShops *)getInstance {
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [ShopSDKShops new];
        }
    }
    return _instance;
}

/************************************ REQUESTS SECTION START ************************************/

- (void)getShop:(long)shopId merchantNumber:(NSString*)merchantNumber callback:(void (^)(BOOL success, Shop *shop, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForGetShop:shopId merchantNumber:merchantNumber];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"GetShop" callback:^(BOOL success, id resultObject) {
        if (success) {
            NSDictionary *responseDict = [parser getDictionary:@"d" from:resultObject];
            if (responseDict != nil) {
                // Parse response
                Shop *shop = [parser parseShop:responseDict];
                if (callback) callback(YES, shop, @"");
            } else {
                if (callback) callback(NO, nil, NSLocalizedStringFromTable(@"ShopErrorNoShop", @"CoriunderStrings", @""));
            }
        } else {
            if (callback) callback(NO, nil, [parser parseError:resultObject]);
        }
    }];
}

- (void)getShopIds:(NSString*)subDomainName callback:(void (^)(BOOL success, NSString *merchantNumber, long shopId, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForGetShopIds:subDomainName];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"GetShopIds" callback:^(BOOL success, id resultObject) {
        if (success) {
            NSDictionary *responseDict = [parser getDictionary:@"d" from:resultObject];
            if (responseDict != nil) {
                // Parse response
                NSString *merchant = [parser getString:@"MerchantNumber" from:responseDict];
                long shopId = [parser getLong:@"ShopId" from:responseDict];
                if (callback) callback(YES, merchant, shopId, @"");
            } else {
                if (callback) callback(NO, @"", 0, NSLocalizedStringFromTable(@"ShopErrorNoShop", @"CoriunderStrings", @""));
            }
        } else {
            if (callback) callback(NO, @"", 0, [parser parseError:resultObject]);
        }
    }];
}

- (void)getShopsForMerchant:(NSString*)merchantNumber culture:(NSString*)culture callback:(void (^)(BOOL success, NSMutableArray<Shop*> *result, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForGetShops:merchantNumber culture:culture];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"GetShops" callback:^(BOOL success, id resultObject) {
        if (success) {
            // Parse response
            NSMutableArray *shops = [parser parseShops:resultObject];
            if (callback) callback(YES, shops, @"");
        } else {
            if (callback) callback(NO, [NSMutableArray new], [parser parseError:resultObject]);
        }
    }];
}

- (void)getShopsAtRegions:(NSArray<NSString*>*)regions countries:(NSArray<NSString*>*)countries includeGlobalShops:(BOOL)includeGlobalShops culture:(NSString*)culture callback:(void (^)(BOOL success, NSMutableArray<Shop*> *result, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForGetShopsByLocation:regions countries:countries
                                                includeGlobalShops:includeGlobalShops culture:culture];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"GetShopsByLocation" callback:^(BOOL success, id resultObject) {
        if (success) {
            // Parse response
            NSMutableArray *shops = [parser parseShops:resultObject];
            if (callback) callback(YES, shops, @"");
        } else {
            if (callback) callback(NO, [NSMutableArray new], [parser parseError:resultObject]);
        }
    }];
}

- (void)setSessionWithDeclineUrl:(NSString*)declineUrl imageHeight:(long)imageHeight imageWidth:(long)imageWidth pendingUrl:(NSString*)pendingUrl successUrl:(NSString*)successUrl callback:(void (^)(BOOL success, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForSetSession:declineUrl imageHeight:imageHeight imageWidth:imageWidth pendingUrl:pendingUrl successUrl:successUrl appToken:[self getAppToken]];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"SetSession" callback:[parser createBasicCallbackWithUserCallback:callback getSuccess:NO]];
}

/************************************* REQUESTS SECTION END *************************************/

@end
