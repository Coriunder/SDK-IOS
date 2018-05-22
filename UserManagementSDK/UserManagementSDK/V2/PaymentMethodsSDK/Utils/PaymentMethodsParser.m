//
//  PaymentMethodsParser.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Parser methods for PaymentMethods services

#import "PaymentMethodsParser.h"

@implementation PaymentMethodsParser

- (PaymentMethod*)parsePaymentMethod:(NSDictionary*)paymentDict {
    PaymentMethod *paymentMethod = [PaymentMethod new];
    [paymentMethod setAccountValue1:[self getString:@"AccountValue1" from:paymentDict]];
    [paymentMethod setAccountValue2:[self getString:@"AccountValue2" from:paymentDict]];
    [paymentMethod setAddress:[self parseAddress:[self getDictionary:@"BillingAddress" from:paymentDict]]];
    [paymentMethod setDisplay:[self getString:@"Display" from:paymentDict]];
    [paymentMethod setExpirationDate:[self getReadableDate:@"ExpirationDate" from:paymentDict]];
    [paymentMethod setPaymentMethodId:[self getLong:@"ID" from:paymentDict]];
    [paymentMethod setIconURL:[self getString:@"Icon" from:paymentDict]];
    [paymentMethod setIsDefault:[self getBool:@"IsDefault" from:paymentDict]];
    [paymentMethod setIssuerCountryIsoCode:[self getString:@"IssuerCountryIsoCode" from:paymentDict]];
    [paymentMethod setLast4Digits:[self getString:@"Last4Digits" from:paymentDict]];
    [paymentMethod setOwnerName:[self getString:@"OwnerName" from:paymentDict]];
    [paymentMethod setPaymentMethodGroupKey:[self getString:@"PaymentMethodGroupKey" from:paymentDict]];
    [paymentMethod setPaymentMethodKey:[self getString:@"PaymentMethodKey" from:paymentDict]];
    [paymentMethod setTitle:[self getString:@"Title" from:paymentDict]];
    return paymentMethod;
}

- (NSMutableArray*)parseAddresses:(id)resultObject {
    NSArray *result = [self getArray:@"d" from:resultObject];
    NSMutableArray *addressesArray = [NSMutableArray new];
    if (result != nil) {
        for (NSDictionary *addressDict in result) {
            Address *address = [self parseAddress:addressDict];
            [addressesArray addObject:address];
        }
    }
    return addressesArray;
}

- (NSMutableArray*)parsePaymentMethodsTypes:(NSDictionary*)paymentDict {
    NSArray *rootGroupResult = [self getArray:@"PaymentMethodGroups" from:paymentDict];
    NSArray *subrootGroupResult = [self getArray:@"PaymentMethods" from:paymentDict];
    if (rootGroupResult == nil) rootGroupResult = [NSArray new];
    if (subrootGroupResult == nil) subrootGroupResult = [NSMutableArray new];
    NSMutableArray *paymentGroups = [NSMutableArray new];
    
    // Storing all subRoots by roots
    NSMutableDictionary *roots = [NSMutableDictionary new];
    for (NSDictionary *subgroup in subrootGroupResult) {
        NSString *key = [self getString:@"GroupKey" from:subgroup];
        
        // Creating/getting temporary root
        PaymentCardRootGroup *rootModel = [roots objectForKey:key];
        if (rootModel == nil) {
            rootModel = [PaymentCardRootGroup new];
            rootModel.key = key;
            rootModel.name = [NSString stringWithFormat:@"Group %@",key];
            rootModel.subGroups = [NSMutableArray new];
            [roots setObject:rootModel forKey:key];
        }
        
        PaymentCardSubrootGroup *subrootModel = [PaymentCardSubrootGroup new];
        subrootModel.icon = [self getString:@"Icon" from:subgroup];
        subrootModel.key = [self getString:@"Key" from:subgroup];
        subrootModel.name = [self getString:@"Name" from:subgroup];
        subrootModel.groupKey = [self getString:@"GroupKey" from:subgroup];
        subrootModel.hasExpirationDate = [self getBool:@"HasExpirationDate" from:subgroup];
        subrootModel.value1Caption = [self getString:@"Value1Caption" from:subgroup];
        subrootModel.value1ValidationRegex = [self getString:@"Value1ValidationRegex" from:subgroup];
        subrootModel.value2Caption = [self getString:@"Value2Caption" from:subgroup];
        subrootModel.value2ValidationRegex = [self getString:@"Value2ValidationRegex" from:subgroup];
        [rootModel.subGroups addObject:subrootModel];
    }
    
    //Storing root data
    NSMutableDictionary *rootsData = [NSMutableDictionary new];
    for (NSDictionary *group in rootGroupResult) {
        NSString *key = [self getString:@"Key" from:group];
        
        PaymentCardRootGroup *rootModel = [PaymentCardRootGroup new];
        rootModel.icon = [self getString:@"Icon" from:group];
        rootModel.key = key;
        rootModel.name = [self getString:@"Name" from:group];
        [rootsData setObject:rootModel forKey:key];
    }
    
    //Setting real root data to roots which hold subRoots
    NSArray *allKeys =[roots allKeys];
    for (NSString *key in allKeys) {
        PaymentCardRootGroup *rootModel = [rootsData objectForKey:key];
        PaymentCardRootGroup *savedRoot = [roots objectForKey:key];
        if (rootModel != nil) {
            savedRoot.icon = rootModel.icon;
            savedRoot.key = rootModel.key;
            savedRoot.name = rootModel.name;
        }
        [paymentGroups addObject:savedRoot];
    }
    return paymentGroups;
}

- (NSMutableArray*)parsePaymentMethods:(id)resultObject {
    NSArray *result = [self getArray:@"d" from:resultObject];
    NSMutableArray *paymentArray = [NSMutableArray new];
    if (result != nil) {
        for (NSDictionary *paymentDict in result) {
            PaymentMethod *paymentMethod = [self parsePaymentMethod:paymentDict];
            [paymentArray addObject:paymentMethod];
        }
    }
    return paymentArray;
}

@end
