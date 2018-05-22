//
//  InternationalSDK.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods to perform requests to the International service

#import "Coriunder.h"
#import "ServiceResult.h"
#import "CurrencyRate.h"
#import "Language.h"
#import "Country.h"
#import "State.h"

@interface InternationalSDK : Coriunder

/**
 * Get instance for InternationalSDK class.
 * In case there is no current instance, a new one will be created
 * @return InternationalSDK instance
 */
+ (InternationalSDK*)getInstance;



/**
 * Get currency rates
 *
 * @param callback will be called after request completion
 */
- (void)getCurrencyRatesWithCallback:(void (^)(BOOL success, NSMutableArray<CurrencyRate*> *ratesArray, NSString* message))callback;

/**
 * Get list of possible errors
 *
 * @param language language which you want to receive errors with
 * @param groups groups of errors you need to get info about
 * @param callback will be called after request completion
 */
- (void)getErrorCodesWithLanguage:(NSString*)language groups:(NSArray<NSString*>*)groups callback:(void (^)(BOOL success, NSMutableArray<ServiceResult*> *errorsArray, NSString* message))callback;

/**
 * Get list of countries, Canada states, USA states and languages
 *
 * @param callback will be called after request completion
 */
- (void)getCountriesStatesAndLanguagesWithCallback:(void (^)(BOOL success, NSMutableArray<Language*> *languages,
                                                             NSMutableArray<Country*> *countries, NSMutableArray<State*> *canadaStates,
                                                             NSMutableArray<State*> *usaStates, NSString* message))callback;

@end
