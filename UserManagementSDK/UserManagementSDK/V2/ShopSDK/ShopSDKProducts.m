//
//  ShopSDKProducts.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods to perform requests to the Shop service related to products

#import "ShopSDKProducts.h"
#import "ShopRequestBuilder.h"
#import "ShopParser.h"

@implementation ShopSDKProducts

static ShopSDKProducts *_instance = nil;
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

+ (ShopSDKProducts *)getInstance {
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [ShopSDKProducts new];
        }
    }
    return _instance;
}

/************************************ REQUESTS SECTION START ************************************/

- (void)getProductsOfCategory:(long)category shopId:(long)shopId language:(NSString*)language callback:(void (^)(BOOL success, NSMutableArray<Product*> *products, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForGetCategorisedProducts:category shopId:shopId language:language];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"GetCategorisedProducts" callback:^(BOOL success, id resultObject) {
        if (success) {
            // Parse response
            NSMutableArray *products = [parser parseProducts:resultObject];
            if (callback) callback(YES, products, @"");
        } else {
            if (callback) callback(NO, [NSMutableArray new], [parser parseError:resultObject]);
        }
    }];
}

- (void)getProductWithId:(long)productId merchantNumber:(NSString*)merchantNumber language:(NSString*)language callback:(void (^)(BOOL success, Product *product, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForGetProduct:productId merchantNumber:merchantNumber language:language];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"GetProduct" callback:^(BOOL success, id resultObject) {
        if (success) {
            NSDictionary *result = [parser getDictionary:@"d" from:resultObject];
            if (result != nil) {
                // Parse response
                Product *product = [parser parseProduct:result];
                if (callback) callback(YES, product, @"");
            } else {
                if (callback) callback(NO, nil, NSLocalizedStringFromTable(@"ShopErrorNoProduct", @"CoriunderStrings", @""));
            }
        } else {
            if (callback) callback(NO, nil, [parser parseError:resultObject]);
        }
    }];
}

/*
 ToDoV2:
 NSArray<NSNumber*> are really int arrays
 */
- (void)getProductsOnPage:(int)page pageSize:(int)pageSize categories:(NSArray<NSNumber*>*)categories countries:(NSArray<NSString*>*)countries includeGlobalRegion:(BOOL)includeGlobalRegion language:(NSString*)language merchantGroups:(NSArray<NSNumber*>*)merchantGroups merchantId:(NSString*)merchantId name:(NSString*)name promoOnly:(BOOL)promoOnly regions:(NSArray<NSString*>*)regions shopId:(long)shopId tags:(NSString*)tags callback:(void (^)(BOOL success, NSMutableArray<Product*> *products, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForGetProducts:page pageSize:pageSize categories:categories
                                                  countries:countries includeGlobalRegion:includeGlobalRegion
                                                   language:language merchantGroups:merchantGroups merchantId:merchantId
                                                       name:name promoOnly:promoOnly regions:regions shopId:shopId tags:tags];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"GetProducts" callback:^(BOOL success, id resultObject) {
        if (success) {
            // Parse response
            NSMutableArray *products = [parser parseProducts:resultObject];
            if (callback) callback(YES, products, @"");
        } else {
            if (callback) callback(NO, [NSMutableArray new], [parser parseError:resultObject]);
        }
    }];
}

/************************************* REQUESTS SECTION END *************************************/

@end
