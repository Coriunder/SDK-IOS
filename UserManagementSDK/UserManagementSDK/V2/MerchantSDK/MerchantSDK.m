//
//  MerchantSDK.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods to perform requests to the Merchant service

#import "MerchantSDK.h"
#import "MerchantRequestBuilder.h"
#import "BaseParser.h"

@implementation MerchantSDK

static MerchantSDK *_instance = nil;
static MerchantRequestBuilder *builder;
static BaseParser *parser;

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.serviceUrlPart = @"Merchant.svc";
        builder = [MerchantRequestBuilder new];
        parser = [BaseParser new];
    }
    return self;
}

+ (MerchantSDK *)getInstance {
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [MerchantSDK new];
        }
    }
    return _instance;
}

/************************************ REQUESTS SECTION START ************************************/

- (void)registerMerchant:(RegistrationMerchant*)merchant callback:(void (^)(BOOL success, NSString* message))callback {
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildRegisterMerchantJson:merchant];
    if (params == nil) {
        if (callback) callback(NO, NSLocalizedStringFromTable(@"ErrorCreatingRequest", @"CoriunderStrings", @""));
        return;
    }
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"Register" callback:[parser createBasicCallbackWithUserCallback:callback getSuccess:NO]];
}

/************************************* REQUESTS SECTION END *************************************/

@end
