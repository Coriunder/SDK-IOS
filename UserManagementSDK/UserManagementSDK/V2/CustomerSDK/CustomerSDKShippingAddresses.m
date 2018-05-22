//
//  CustomerSDKShippingAddresses.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods to perform requests to the Customer service related to shipping addresses

#import "CustomerSDKShippingAddresses.h"
#import "CustomerRequestBuilder.h"
#import "CustomerParser.h"

@implementation CustomerSDKShippingAddresses

static CustomerSDKShippingAddresses *_instance = nil;
static CustomerRequestBuilder *builder;
static CustomerParser *parser;

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.serviceUrlPart = @"Customer.svc";
        builder = [CustomerRequestBuilder new];;
        parser = [CustomerParser new];
    }
    return self;
}

+ (CustomerSDKShippingAddresses *)getInstance {
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [CustomerSDKShippingAddresses new];
        }
    }
    return _instance;
}

/************************************ REQUESTS SECTION START ************************************/

- (void)deleteShippingAddressWithId:(long)addressId callback:(void (^)(BOOL success, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForDeleteAddress:addressId];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"DeleteShippingAddress" callback:^(BOOL success, id resultObject) {
        if (success) {
            // Parse response
            bool success = [parser getBool:@"d" from:resultObject];
            if (callback) callback(success, success ? @"" : NSLocalizedStringFromTable(@"CustomerErrorNoItem", @"CoriunderStrings", @""));
        } else {
            if (callback) callback(NO, [parser parseError:resultObject]);
        }
    }];
}

- (void)getShippingAddressWithId:(long)addressId callback:(void (^)(BOOL success, ShippingAddress *address, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForGetAddress:addressId];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"GetShippingAddress" callback:^(BOOL success, id resultObject) {
        if (success) {
            NSDictionary *result = [parser getDictionary:@"d" from:resultObject];
            if (result != nil) {
                // Parse response
                ShippingAddress *address = [parser parseShippingAddress:result];
                if (callback) callback(YES, address, @"");
            } else {
                if (callback) callback(NO, nil, NSLocalizedStringFromTable(@"CustomerErrorNoItem", @"CoriunderStrings", @""));
            }
        } else {
            if (callback) callback(NO, nil, [parser parseError:resultObject]);
        }
    }];
}

- (void)getShippingAddressesWithCallback:(void (^)(BOOL success, NSMutableArray<ShippingAddress*>* addressesArray, NSString* message))callback {
    // Create request
    [self sendPostRequestWithParameters:nil withMethod:@"GetShippingAddresses" callback:^(BOOL success, id resultObject) {
        if (success) {
            // Parse response
            NSMutableArray *addressesArray = [parser parseShippingAddresses:resultObject];
            if (callback) callback(YES, addressesArray, @"");
        } else {
            if (callback) callback(NO, [NSMutableArray new], [parser parseError:resultObject]);
        }
    }];
}

- (void)addNewShippingAddress:(ShippingAddress*)shippingAddress callback:(void (^)(BOOL success, ServiceMultiResult *result, NSString* message))callback {
    // Parse ShippingAddress object to NSDictionary
    NSDictionary* address = [builder buildAddressJson:shippingAddress isNew:true];
    // Prepare and perform request
    [self saveShippingAddress:address callback:callback];
}

- (void)updateShippingAddress:(ShippingAddress*)shippingAddress callback:(void (^)(BOOL success, ServiceMultiResult *result, NSString* message))callback {
    // Parse ShippingAddress object to NSDictionary
    NSDictionary* address = [builder buildAddressJson:shippingAddress isNew:false];
    // Prepare and perform request
    [self saveShippingAddress:address callback:callback];
}

/**
 * Common method to add or update shipping address
 *
 * @param addressJson NSDictionary containing shipping address data
 * @param callback will be called after request completion
 */
- (void)saveShippingAddress:(NSDictionary*)params callback:(void (^)(BOOL success, ServiceMultiResult *result, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *addressDict = [builder buildJsonForSaveAddress:params];
    if (addressDict == nil) {
        if (callback) callback(NO, [ServiceMultiResult new], NSLocalizedStringFromTable(@"ErrorCreatingRequest", @"CoriunderStrings", @""));
        return;
    }
    
    // Create request
    [self sendPostRequestWithParameters:addressDict withMethod:@"SaveShippingAddress" callback:[parser createServiceMultiCallbackWithUserCallback:callback]];
}

- (void)saveShippingAddresses:(NSArray<ShippingAddress*>*)shippingAddresses callback:(void (^)(BOOL success, ServiceMultiResult *result, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *addressDict = [builder buildJsonForSaveAddresses:shippingAddresses];
    if (addressDict == nil) {
        if (callback) callback(NO, [ServiceMultiResult new], NSLocalizedStringFromTable(@"ErrorCreatingRequest", @"CoriunderStrings", @""));
        return;
    }
    
    // Create request
    [self sendPostRequestWithParameters:addressDict withMethod:@"SaveShippingAddresses" callback:[parser createServiceMultiCallbackWithUserCallback:callback]];
}

/************************************* REQUESTS SECTION END *************************************/

@end
