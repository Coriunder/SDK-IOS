//
//  PaymentMethodsSDK.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods to perform requests to the PaymentMethods service

#import "PaymentMethodsSDK.h"
#import "PaymentMethodsRequestBuilder.h"
#import "PaymentMethodsParser.h"

@implementation PaymentMethodsSDK

static PaymentMethodsSDK *_instance = nil;
static PaymentMethodsRequestBuilder *builder;
static PaymentMethodsParser *parser;

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.serviceUrlPart = @"PaymentMethods.svc";
        builder = [PaymentMethodsRequestBuilder new];
        parser = [PaymentMethodsParser new];
    }
    return self;
}

+ (PaymentMethodsSDK *)getInstance {
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [PaymentMethodsSDK new];
        }
    }
    return _instance;
}

/************************************ REQUESTS SECTION START ************************************/

- (void)deletePaymentMethodWithId:(long)cardId callback:(void (^)(BOOL success, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForDeletePm:cardId];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"DeleteStoredPaymentMethod" callback:^(BOOL success, id resultObject) {
        if (success) {
            // Parse response
            bool success = [parser getBool:@"d" from:resultObject];
            if (callback) callback(success, success ? @"" : NSLocalizedStringFromTable(@"PmsErrorNoItem", @"CoriunderStrings", @""));
        } else {
            if (callback) callback(NO, [parser parseError:resultObject]);
        }
    }];
}

- (void)getBillingAddressesWithCallback:(void (^)(BOOL success, NSMutableArray<Address*> *array, NSString* message))callback {
    // Create request
    [self sendPostRequestWithParameters:nil withMethod:@"GetBillingAddresses" callback:^(BOOL success, id resultObject) {
        if (success) {
            // Parse response
            NSMutableArray *addressesArray = [parser parseAddresses:resultObject];
            if (callback) callback(YES, addressesArray, @"");
        } else {
            if (callback) callback(NO, [NSMutableArray new], [parser parseError:resultObject]);
        }
    }];
}

- (void)getPaymentMethodsTypes:(void (^)(BOOL success, NSMutableArray<PaymentCardRootGroup*> *paymentGroups, NSString* message))callback {
    // Create request
    [self sendPostRequestWithParameters:nil withMethod:@"GetStaticData" callback:^(BOOL success, id resultObject) {
        if (success) {
            NSDictionary *result = [parser getDictionary:@"d" from:resultObject];
            if (result != nil) {
                // Parse response
                NSMutableArray *paymentGroups = [parser parsePaymentMethodsTypes:result];
                if (callback) callback(YES, paymentGroups, @"");
            } else {
                if (callback) callback(NO, [NSMutableArray new], NSLocalizedStringFromTable(@"EmptyResponseError", @"CoriunderStrings", @""));
            }
        } else {
            if (callback) callback(NO, [NSMutableArray new], [parser parseError:resultObject]);
        }
    }];
}

- (void)getPaymentMethodWithId:(long)cardId callback:(void (^)(BOOL success, PaymentMethod *paymentMethod, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForGetPm:cardId];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"GetStoredPaymentMethod" callback:^(BOOL success, id resultObject) {
        if (success) {
            NSDictionary *result = [parser getDictionary:@"d" from:resultObject];
            if (result != nil) {
                // Parse response
                PaymentMethod *paymentMethod = [parser parsePaymentMethod:result];
                if (callback) callback(YES, paymentMethod, @"");
            } else {
                if (callback) callback(NO, nil, NSLocalizedStringFromTable(@"PmsErrorNoItem", @"CoriunderStrings", @""));
            }
        } else {
            if (callback) callback(NO, nil, [parser parseError:resultObject]);
        }
    }];
}

- (void)getPaymentMethodsWithCallback:(void (^)(BOOL success, NSMutableArray<PaymentMethod*>* paymentMethodsArray, NSString* message))callback {
    // Create request
    [self sendPostRequestWithParameters:nil withMethod:@"GetStoredPaymentMethods" callback:^(BOOL success, id resultObject) {
        if (success) {
            // Parse response
            NSMutableArray *paymentArray = [parser parsePaymentMethods:resultObject];
            if (callback) callback(YES, paymentArray, @"");
        } else {
            if (callback) callback(NO, [NSMutableArray new], [parser parseError:resultObject]);
        }
    }];
}

- (void)linkPaymentMethodWithAccountValue:(NSString*)accountValue birthDate:(NSDate*)bDate personalNumber:(NSString*)personalNumber phoneNumber:(NSString*)phoneNumber callback:(void (^)(BOOL success, ServiceResult *result, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForLinkPm:accountValue birthDate:bDate personalNumber:personalNumber phoneNumber:phoneNumber];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"LinkPaymentMethod" callback:[parser createServiceCallbackWithUserCallback:callback]];
}

- (void)loadPaymentMethodWithAmount:(double)amount currencyIso:(NSString*)currencyIso paymentMethodId:(long)paymentMethodId pinCode:(NSString*)pinCode referenceCode:(NSString*)referenceCode callback:(void (^)(BOOL success, ServiceResult *result, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForLoadPm:amount currencyIso:currencyIso paymentMethodId:paymentMethodId pinCode:pinCode referenceCode:referenceCode];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"LoadPaymentMethod" callback:[parser createServiceCallbackWithUserCallback:callback]];
}

- (void)requestPhysicalPaymentMethodWithProviderId:(NSString*)providerID addressLine1:(NSString*)addressLine1 addressLine2:(NSString*)addressLine2 city:(NSString*)city countryIso:(NSString*)countryIso postalCode:(NSString*)postalCode stateIso:(NSString*)stateIso callback:(void (^)(BOOL success, ServiceResult *result, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForRequestPhysicalPm:providerID addressLine1:addressLine1 addressLine2:addressLine2 city:city countryIso:countryIso postalCode:postalCode stateIso:stateIso];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"RequestPhysicalPaymentMethod" callback:[parser createServiceCallbackWithUserCallback:callback]];
}

- (void)addNewPaymentMethod:(PaymentMethod*)paymentMethod callback:(void (^)(BOOL success, ServiceResult *result, NSString* message))callback {
    // Parse PaymentMethod object to NSDictionary
    NSDictionary *methodData = [builder buildCardJson:paymentMethod isNew:true];
    // Prepare and perform request
    [self savePaymentMethod:methodData callback:callback];
}

- (void)updatePaymentMethod:(PaymentMethod*)paymentMethod callback:(void (^)(BOOL success, ServiceResult *result, NSString* message))callback {
    // Parse PaymentMethod object to NSDictionary
    NSDictionary *methodData = [builder buildCardJson:paymentMethod isNew:false];
    // Prepare and perform request
    [self savePaymentMethod:methodData callback:callback];
}

/**
 * Common method to add or update payment method
 *
 * @param methodData NSDictionary containing payment method data
 * @param callback will be called after request completion
 */
- (void)savePaymentMethod:(NSDictionary*)methodData callback:(void (^)(BOOL success, ServiceResult *result, NSString* message))callback {
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForSavePm:methodData];
    if (params == nil) {
        if (callback) callback(NO, [ServiceResult new], NSLocalizedStringFromTable(@"ErrorCreatingRequest", @"CoriunderStrings", @""));
        return;
    }
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"StorePaymentMethod" callback:[parser createServiceCallbackWithUserCallback:callback]];
}

- (void)savePaymentMethods:(NSArray<PaymentMethod*>*)paymentMethods callback:(void (^)(BOOL success, ServiceMultiResult *result, NSString* message))callback {
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForSavePms:paymentMethods];
    if (params == nil) {
        if (callback) callback(NO, [ServiceMultiResult new], NSLocalizedStringFromTable(@"ErrorCreatingRequest", @"CoriunderStrings", @""));
        return;
    }
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"StorePaymentMethods" callback:[parser createServiceMultiCallbackWithUserCallback:callback]];
}

/************************************* REQUESTS SECTION END *************************************/

@end
