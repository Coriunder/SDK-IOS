//
//  CustomerSDKCustomers.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods to perform requests to the Customer service related to customer data

#import "CustomerSDKCustomers.h"
#import "CustomerRequestBuilder.h"
#import "CustomerParser.h"

@implementation CustomerSDKCustomers

static CustomerSDKCustomers *_instance = nil;
static CustomerRequestBuilder *builder;
static CustomerParser *parser;

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.serviceUrlPart = @"Customer.svc";
        builder = [CustomerRequestBuilder new];
        parser = [CustomerParser new];
    }
    return self;
}

+ (CustomerSDKCustomers *)getInstance {
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [CustomerSDKCustomers new];
        }
    }
    return _instance;
}

/************************************ REQUESTS SECTION START ************************************/

- (void)getCustomerWithCallback:(void (^)(BOOL success, Customer* customer, NSString* message))callback {
    // Create request
    [self sendPostRequestWithParameters:nil withMethod:@"GetCustomer" callback:^(BOOL success, id resultObject) {
        if (success) {
            if (resultObject != nil) {
                // Parse response
                Customer* customer = [parser parseCustomer:resultObject];
                if (callback) callback(YES, customer, @"");
            } else {
                if (callback) callback(NO, nil, NSLocalizedStringFromTable(@"EmptyResponseError", @"CoriunderStrings", @""));
            }
        } else {
            if (callback) callback(NO, nil, [parser parseError:resultObject]);
        }
    }];
}

- (void)getImageForUserWithId:(NSString*)userId asRaw:(BOOL)asRaw callback:(void (^)(BOOL success, UIImage* image, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForGetImage:userId asRaw:asRaw];
    
    // Create request
    [self sendGetRequestWithParameters:params withMethod:@"GetImage" callback:^(BOOL success, id resultObject) {
        if (success) {
            if (callback) callback(YES, [UIImage imageWithData:resultObject], nil);
        } else {
            if (callback) callback(NO, nil, [parser parseError:resultObject]);
        }
    }];
}

/*
 ToDoV2:
 No login after signUp
 */
- (void)registerUserWithPassword:(NSString*)password pinCode:(NSString*)pinCode email:(NSString*)email firstName:(NSString*)firstName lastName:(NSString*)lastName callback:(void (^)(BOOL success, ServiceResult *result, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForRegisterCustomer:password pinCode:pinCode email:email
                                                       firstName:firstName lastName:lastName appToken:[self getAppToken]];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"RegisterCustomer" callback:[parser createServiceCallbackWithUserCallback:callback]];
}

- (void)saveCustomerWithFirstName:(NSString*)firstName lastName:(NSString*)lastName email:(NSString*)email addressLine1:(NSString*)addressLine1 addressLine2:(NSString*)addressLine2 city:(NSString*)city countryIso:(NSString*)countryIso postalCode:(NSString*)postalCode stateIso:(NSString*)stateIso cellNumber:(NSString*)cellNumber birthDate:(NSDate*)birthDate personalNumber:(NSString*)personalNumber phoneNumber:(NSString*)phoneNumber profileImage:(UIImage*)profileImage callback:(void (^)(BOOL success, Customer* customer, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForSaveCustomer:firstName lastName:lastName email:email addressLine1:addressLine1 addressLine2:addressLine2 city:city countryIso:countryIso postalCode:postalCode stateIso:stateIso cellNumber:cellNumber birthDate:birthDate personalNumber:personalNumber phoneNumber:phoneNumber profileImage:profileImage];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"SaveCustomer" callback:^(BOOL success, id resultObject) {
        if (success) {
            // Parse response
            NSDictionary *registerResult = [parser getDictionary:@"d" from:resultObject];
            if ([parser getBool:@"IsSuccess" from:registerResult]) {
                // Get customer data
                [self getCustomerWithCallback:^(BOOL success, Customer *customer, NSString *message) {
                    if (success) {
                        if (callback) callback(YES, customer, message);
                    } else {
                        if (callback) callback(YES, [Customer new], NSLocalizedStringFromTable(@"CustomerErrorRegister", @"CoriunderStrings", @""));
                    }
                }];
            } else {
                if (callback) callback(NO, nil, [parser getString:@"Message" from:registerResult]);
            }
        } else {
            if (callback) callback(NO, nil, [parser parseError:resultObject]);
        }
    }];
}

/************************************* REQUESTS SECTION END *************************************/

@end
