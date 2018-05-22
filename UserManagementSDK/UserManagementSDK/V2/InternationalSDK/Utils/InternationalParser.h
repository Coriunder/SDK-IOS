//
//  InternationalParser.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Parser methods for International services

#import "BaseParser.h"
#import "CurrencyRate.h"
#import "Country.h"
#import "Language.h"
#import "State.h"

@interface InternationalParser : BaseParser

/**
 * Method to parse result to NSMutableArray containing CurrencyRate objects
 * @param resultObject result to parse
 * @return NSMutableArray containing CurrencyRate objects
 */
- (NSMutableArray*)parseCurrencyRates:(id)resultObject;

/**
 * Method to parse result to NSMutableArray containing ServiceResult objects
 * @param resultObject result to parse
 * @return NSMutableArray containing ServiceResult objects
 */
- (NSMutableArray*)parseErrorCodes:(id)resultObject;

/**
 * Method to parse result to NSMutableArray containing Country objects
 * @param result result to parse
 * @return NSMutableArray containing Country objects
 */
- (NSMutableArray*)parseCountries:(NSDictionary*)result;

/**
 * Method to parse result to NSMutableArray containing Language objects
 * @param result result to parse
 * @return NSMutableArray containing Language objects
 */
- (NSMutableArray*)parseLanguages:(NSDictionary*)result;

/**
 * Method to parse result to NSMutableArray containing State objects
 * @param result result to parse
 * @param isCanada boolean to set whether Canada or USA states being parsed
 * @return NSMutableArray containing State objects
 */
- (NSMutableArray*)parseStates:(NSDictionary*)result isCanada:(BOOL)isCanada;

@end
