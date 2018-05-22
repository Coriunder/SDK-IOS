//
//  InternationalParser.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Parser methods for International services

#import "InternationalParser.h"

@implementation InternationalParser

- (NSMutableArray*)parseCurrencyRates:(id)resultObject {
    NSArray *result = [self getArray:@"d" from:resultObject];
    NSMutableArray *ratesArray = [NSMutableArray new];
    if (result != nil) {
        for (NSDictionary *modelToParse in result) {
            CurrencyRate *model = [CurrencyRate new];
            model.key = [self getString:@"Key" from:modelToParse];
            model.value = [self getDouble:@"Value" from:modelToParse];
            [ratesArray addObject:model];
        }
    }
    return ratesArray;
}

- (NSMutableArray*)parseErrorCodes:(id)resultObject {
    NSArray *result = [self getArray:@"d" from:resultObject];
    NSMutableArray *errorsArray = [NSMutableArray new];
    if (result != nil) {
        for (NSDictionary *modelToParse in result) {
            ServiceResult *model = [self parseServiceResult:modelToParse];
            [errorsArray addObject:model];
        }
    }
    return errorsArray;
}

- (NSMutableArray*)parseCountries:(NSDictionary*)result {
    NSArray *countriesArray = [self getArray:@"Countries" from:result];
    NSMutableArray *countries = [NSMutableArray new];
    if (countriesArray != nil) {
        for (NSDictionary *modelDictionary in countriesArray) {
            Country *country = [Country new];
            country.key = [self getString:@"Key" from:modelDictionary];
            country.name = [self getString:@"Name" from:modelDictionary];
            country.icon = [self getString:@"Icon" from:modelDictionary];
            [countries addObject:country];
        }
    }
    return countries;
}

- (NSMutableArray*)parseLanguages:(NSDictionary*)result {
    NSArray *languagesArray = [self getArray:@"Languages" from:result];
    NSMutableArray *languages = [NSMutableArray new];
    if (languagesArray != nil) {
        for (NSDictionary *modelDictionary in languagesArray) {
            Language *language = [Language new];
            language.key = [self getString:@"Key" from:modelDictionary];
            language.name = [self getString:@"Name" from:modelDictionary];
            language.icon = [self getString:@"Icon" from:modelDictionary];
            [languages addObject:language];
        }
    }
    return languages;
}

- (NSMutableArray*)parseStates:(NSDictionary*)result isCanada:(BOOL)isCanada {
    NSArray *statesArray = [self getArray:(isCanada ? @"CanadaStates" : @"UsaStates") from:result];
    NSMutableArray *states = [NSMutableArray new];
    if (statesArray != nil) {
        for (NSDictionary *modelDictionary in statesArray) {
            State *state = [State new];
            state.key = [self getString:@"Key" from:modelDictionary];
            state.name = [self getString:@"Name" from:modelDictionary];
            state.icon = [self getString:@"Icon" from:modelDictionary];
            [states addObject:state];
        }
    }
    return states;
}

@end
