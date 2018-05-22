//
//  ShopSDKMerchants.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods to perform requests to the Shop service related to merchants

#import "ShopSDKMerchants.h"
#import "ShopRequestBuilder.h"
#import "ShopParser.h"

@implementation ShopSDKMerchants

static ShopSDKMerchants *_instance = nil;
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

+ (ShopSDKMerchants *)getInstance {
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [ShopSDKMerchants new];
        }
    }
    return _instance;
}

/************************************ REQUESTS SECTION START ************************************/

- (void)getMerchant:(NSString*)merchantNumber callback:(void (^)(BOOL success, Merchant* merchant, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForGetMerchant:merchantNumber];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"GetMerchant" callback:^(BOOL success, id resultObject) {
        if (success) {
            NSDictionary *merchantDict = [parser getDictionary:@"d" from:resultObject];
            if (merchantDict != nil) {
                // Parse response
                Merchant *merchant = [parser parseMerchant:merchantDict];
                if (callback) callback(YES, merchant, @"");
            } else {
                if (callback) callback(NO, nil, NSLocalizedStringFromTable(@"ShopErrorNoMerchant", @"CoriunderStrings", @""));
            }
        } else {
            if (callback) callback(NO, nil, [parser parseError:resultObject]);
        }
    }];
}

- (void)getCategoriesForMerchant:(NSString*)merchantNumber language:(NSString*)language callback:(void (^)(BOOL success, NSArray<ProductCategory*>* categories, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForGetCategories:merchantNumber language:language];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"GetMerchantCategories" callback:^(BOOL success, id resultObject) {
        if (success) {
            // Parse response
            NSMutableArray *categories = [parser parseCategories:resultObject];
            if (callback) callback(YES, categories, @"");
        } else {
            if (callback) callback(NO, [NSMutableArray new], [parser parseError:resultObject]);
        }
    }];
}

- (void)getContentForMerchant:(NSString*)merchantNumber language:(NSString*)language contentName:(NSString*)contentName callback:(void (^)(BOOL success, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForGetContent:merchantNumber language:language contentName:contentName];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"GetMerchantContent" callback:^(BOOL success, id resultObject) {
        if (success) {
            // Parse response
            NSString *content = [parser getString:@"d" from:resultObject];
            if (callback) callback(YES, content);
        } else {
            if (callback) callback(NO, [parser parseError:resultObject]);
        }
    }];
}

- (void)getMerchantsWithGroup:(long)groupId status:(merchantStatus)status text:(NSString*)text callback:(void (^)(BOOL success, NSMutableArray<Merchant*> *merchants, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForGetMerchants:groupId status:status text:text appToken:[self getAppToken]];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"GetMerchants" callback:^(BOOL success, id resultObject) {
        if (success) {
            // Parse response
            NSMutableArray *merchants = [parser parseMerchants:resultObject];
            if (callback) callback(YES, merchants, @"");
        } else {
            if (callback) callback(NO, [NSMutableArray new], [parser parseError:resultObject]);
        }
    }];
}

/************************************* REQUESTS SECTION END *************************************/

@end
