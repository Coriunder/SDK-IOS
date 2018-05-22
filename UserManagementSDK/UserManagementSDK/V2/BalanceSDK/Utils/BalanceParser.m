//
//  BalanceParser.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Parser methods for Balance services

#import "BalanceParser.h"

@implementation BalanceParser

- (Request*)parseRequest:(NSDictionary*)dictionary {
    Request *item = [Request new];
    [item setAmount:[self getDouble:@"Amount" from:dictionary]];
    [item setConfirmDate:[self getReadableDate:@"ConfirmDate" from:dictionary]];
    [item setCurrencyISOCode:[self getString:@"CurrencyISOCode" from:dictionary]];
    [item setRequestId:[self getLong:@"ID" from:dictionary]];
    [item setIsApproved:[self getBool:@"IsApproved" from:dictionary]];
    [item setIsPush:[self getBool:@"IsPush" from:dictionary]];
    [item setRequestDate:[self getReadableDate:@"RequestDate" from:dictionary]];
    [item setSourceAccountId:[self getLong:@"SourceAccountNumber" from:dictionary]];
    [item setSourceAccountName:[self getString:@"SourceAccountName" from:dictionary]];
    [item setSourceText:[self getString:@"SourceText" from:dictionary]];
    [item setTargetAccountId:[self getLong:@"TargetAccountNumber" from:dictionary]];
    [item setTargetAccountName:[self getString:@"TargetAccountName" from:dictionary]];
    [item setTargetText:[self getString:@"TargetText" from:dictionary]];
    return item;
}

- (NSMutableArray*)parseRequests:(id)resultObject {
    NSArray *result = [self getArray:@"d" from:resultObject];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (result != nil) {
        for (NSDictionary *dictinary in result) {
            Request *item = [self parseRequest:dictinary];
            [array addObject:item];
        }
    }
    return array;
}

- (NSMutableArray*)parseRows:(id)resultObject {
    NSArray *result = [self getArray:@"d" from:resultObject];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (result != nil) {
        for (NSDictionary *dictinary in result) {
            BalanceRow *item = [BalanceRow new];
            [item setAmount:[self getDouble:@"Amount" from:dictinary]];
            [item setCurrencyIso:[self getString:@"CurrencyIso" from:dictinary]];
            [item setBalanceRowId:[self getLong:@"ID" from:dictinary]];
            [item setInsertDate:[self getReadableDate:@"InsertDate" from:dictinary]];
            [item setIsPending:[self getBool:@"IsPending" from:dictinary]];
            [item setSourceId:[self getLong:@"SourceID" from:dictinary]];
            [item setSourceType:[self getString:@"SourceType" from:dictinary]];
            [item setText:[self getString:@"Text" from:dictinary]];
            [item setTotal:[self getDouble:@"Total" from:dictinary]];
            [array addObject:item];
        }
    }
    return array;
}

- (NSMutableArray*)parseTotal:(id)resultObject {
    NSArray *result = [self getArray:@"d" from:resultObject];
    NSMutableArray *balances = [NSMutableArray new];
    if (result != nil) {
        for (NSDictionary *totalDict in result) {
            BalanceTotal *total = [BalanceTotal new];
            [total setCurrencyIso:[self getString:@"CurrencyIso" from:totalDict]];
            [total setCurrent:[self getDouble:@"Current" from:totalDict]];
            [total setExpected:[self getDouble:@"Expected" from:totalDict]];
            [total setPending:[self getDouble:@"Pending" from:totalDict]];
            [balances addObject:total];
        }
    }
    return balances;
}

@end
