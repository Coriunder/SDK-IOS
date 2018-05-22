//
//  AppIdentitySDK.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods to perform requests to the AppIdentity service

#import "AppIdentitySDK.h"
#import "AppIdentityRequestBuilder.h"
#import "AppIdentityParser.h"

@implementation AppIdentitySDK

static AppIdentitySDK *_instance = nil;
static AppIdentityRequestBuilder *builder;
static AppIdentityParser *parser;

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.serviceUrlPart = @"AppIdentity.svc";
        builder = [AppIdentityRequestBuilder new];
        parser = [AppIdentityParser new];
    }
    return self;
}

+ (AppIdentitySDK *)getInstance {
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [AppIdentitySDK new];
        }
    }
    return _instance;
}

/************************************ REQUESTS SECTION START ************************************/

- (void)getContentWithName:(NSString*)contentName callback:(void (^)(BOOL success, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForGetContent:contentName];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"GetContent" callback:^(BOOL success, id resultObject) {
        if (success) {
            // Parse response
            NSString *content = [parser getString:@"d" from:resultObject];
            if (callback) callback(YES, content);
        } else {
            if (callback) callback(NO, [parser parseError:resultObject]);
        }
    }];
}

- (void)getIdentityDetailsWithCallback:(void (^)(BOOL success, Identity *identity, NSString* message))callback {
    
    // Create request
    [self sendPostRequestWithParameters:nil withMethod:@"GetIdentityDetails" callback:^(BOOL success, id resultObject) {
        if (success) {            
            if (resultObject != nil) {
                // Parse response
                Identity *result = [parser parseIdentity:resultObject];
                if (callback) callback(YES, result, @"");
            } else {
                if (callback) callback(NO, [Identity new], NSLocalizedStringFromTable(@"EmptyResponseError", @"CoriunderStrings", @""));
            }
        } else {
            if (callback) callback(NO, [Identity new], [parser parseError:resultObject]);
        }
    }];
}

- (void)getMerchantGroupsWithCallback:(void (^)(BOOL success, NSMutableArray<MerchantGroup*> *result, NSString* message))callback {
    
    // Create request
    [self sendPostRequestWithParameters:nil withMethod:@"GetMerchantGroups" callback:^(BOOL success, id resultObject) {
        if (success) {
            // Parse response
            NSMutableArray *result = [parser parseMerchantGroups:resultObject];
            if (callback) callback(YES, result, @"");            
        } else {
            if (callback) callback(NO, [NSMutableArray new], [parser parseError:resultObject]);
        }
    }];
}

- (void)getSupportedCurrenciesWithCallback:(void (^)(BOOL success, NSArray<NSString*> *result, NSString* message))callback {
    
    // Create request
    [self sendPostRequestWithParameters:nil withMethod:@"GetSupportedCurrencies" callback:[self createArrayCallbackWithUserCallback:callback]];
}

- (void)getSupportedPaymentMethodsWithCallback:(void (^)(BOOL success, NSArray<NSNumber*> *result, NSString* message))callback {
    
    // Create request
    [self sendPostRequestWithParameters:nil withMethod:@"GetSupportedPaymentMethods" callback:[self createArrayCallbackWithUserCallback:callback]];
}

- (void)logWithSeverityId:(int)severityId message:(NSString*)message longMessage:(NSString*)longMessage callback:(void (^)(BOOL success, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForLog:severityId message:message longMessage:longMessage];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"Log" callback:[parser createBasicCallbackWithUserCallback:callback getSuccess:NO]];
}

- (void)sendEmailFrom:(NSString*)from subject:(NSString*)subject body:(NSString*)body callback:(void (^)(BOOL success, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForEmail:from subject:subject body:body];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"SendContactEmail" callback:[parser createBasicCallbackWithUserCallback:callback getSuccess:NO]];
}

/************************************* REQUESTS SECTION END *************************************/

/**
 * @param callback callback to be called on request result
 * @return listener which calls the callback with received array
 */
- (void (^)(BOOL success, id resultObject))createArrayCallbackWithUserCallback:(void (^)(BOOL success, NSArray *result, NSString* message))callback {
    
    return ^(BOOL success, id resultObject) {
        if (success) {
            if (callback) callback(YES, [parser getArray:@"d" from:resultObject], @"");
        } else {
            if (callback) callback(NO, [NSArray new], [parser parseError:resultObject]);
        }
    };
}

@end
