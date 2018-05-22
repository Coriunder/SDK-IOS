//
//  InternationalSDK.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods to perform requests to the International service

#import "InternationalSDK.h"
#import "InternationalRequestBuilder.h"
#import "InternationalParser.h"

@implementation InternationalSDK

static InternationalSDK *_instance = nil;
static InternationalRequestBuilder *builder;
static InternationalParser *parser;

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.serviceUrlPart = @"International.svc";
        builder = [InternationalRequestBuilder new];
        parser = [InternationalParser new];
    }
    return self;
}

+ (InternationalSDK *)getInstance {
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [InternationalSDK new];
        }
    }
    return _instance;
}

/************************************ REQUESTS SECTION START ************************************/

- (void)getCurrencyRatesWithCallback:(void (^)(BOOL success, NSMutableArray<CurrencyRate*> *ratesArray, NSString* message))callback {
    // Create request
    [self sendPostRequestWithParameters:nil withMethod:@"GetCurrencyRates" callback:^(BOOL success, id resultObject) {
        if (success) {
            // Parse response
            NSMutableArray *ratesArray = [parser parseCurrencyRates:resultObject];
            if (callback) callback(YES, ratesArray, @"");
        } else {
            if (callback) callback(NO, [NSMutableArray new], [parser parseError:resultObject]);
        }
    }];
}

- (void)getErrorCodesWithLanguage:(NSString*)language groups:(NSArray<NSString*>*)groups callback:(void (^)(BOOL success, NSMutableArray<ServiceResult*> *errorsArray, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForErrorCodes:language groups:groups];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"GetErrorCodes" callback:^(BOOL success, id resultObject) {
        if (success) {
            // Parse response
            NSMutableArray *errorsArray = [parser parseErrorCodes:resultObject];
            if (callback) callback(YES, errorsArray, @"");
        } else {
            if (callback) callback(NO, [NSMutableArray new], [parser parseError:resultObject]);
        }
    }];
}

- (void)getCountriesStatesAndLanguagesWithCallback:(void (^)(BOOL success, NSMutableArray<Language*> *languages,
                                                             NSMutableArray<Country*> *countries, NSMutableArray<State*> *canadaStates,
                                                             NSMutableArray<State*> *usaStates, NSString* message))callback {
    // Create request
    [self sendPostRequestWithParameters:nil withMethod:@"GetStaticData" callback:^(BOOL success, id resultObject) {
        if (success) {
            // Parse response
            NSDictionary *root = [parser getDictionary:@"d" from:resultObject];
            NSMutableArray *canadaStates = [parser parseStates:root isCanada:YES];
            NSMutableArray *countries = [parser parseCountries:root];
            NSMutableArray *languages = [parser parseLanguages:root];
            NSMutableArray *usaStates = [parser parseStates:root isCanada:NO];
            if (callback) callback(YES, languages, countries, canadaStates, usaStates, @"");
        } else {
            if (callback) callback(NO, [NSMutableArray new], [NSMutableArray new], [NSMutableArray new], [NSMutableArray new], [parser parseError:resultObject]);
        }
    }];
}

/************************************* REQUESTS SECTION END *************************************/

@end
