//
//  AppIdentityParser.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Parser methods for AppIdentity services

#import "AppIdentityParser.h"

@implementation AppIdentityParser

- (Identity*)parseIdentity:(id)resultObject {
    Identity *result = [Identity new];
    NSDictionary *dict = [self getDictionary:@"d" from:resultObject];
    [result setBrandName:[self getString:@"BrandName" from:dict]];
    [result setCompanyName:[self getString:@"CompanyName" from:dict]];
    [result setCopyrightText:[self getString:@"CopyRightText" from:dict]];
    [result setDomainName:[self getString:@"DomainName" from:dict]];
    [result setIsActive:[self getBool:@"IsActive" from:dict]];
    [result setName:[self getString:@"Name" from:dict]];
    [result setTheme:[self getString:@"Theme" from:dict]];
    [result setUrlDevCenter:[self getString:@"URLDevCenter" from:dict]];
    [result setUrlMerchantCP:[self getString:@"URLMerchantCP" from:dict]];
    [result setUrlProcess:[self getString:@"URLProcess" from:dict]];
    [result setUrlWallet:[self getString:@"URLWallet" from:dict]];
    [result setUrlWebsite:[self getString:@"URLWebsite" from:dict]];
    return result;
}

- (NSMutableArray*)parseMerchantGroups:(id)resultObject {
    NSArray *result = [self getArray:@"d" from:resultObject];
    NSMutableArray *array = [NSMutableArray new];
    if (result != nil) {
        for (NSDictionary *dict in result) {
            MerchantGroup *group = [MerchantGroup new];
            group.key = [self getInt:@"Key" from:dict];
            group.value = [self getString:@"Value" from:dict];
            [array addObject:group];
        }
    }
    return array;
}

@end
