//
//  CustomerParser.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Parser methods for Customer services

#import "CustomerParser.h"

@implementation CustomerParser

- (ShippingAddress*)parseShippingAddress:(NSDictionary*)addressDict {
    ShippingAddress *address = [ShippingAddress new];
    [address setAddress1:[self getString:@"AddressLine1" from:addressDict]];
    [address setAddress2:[self getString:@"AddressLine2" from:addressDict]];
    [address setCity:[self getString:@"City" from:addressDict]];
    [address setCountryIso:[self getString:@"CountryIso" from:addressDict]];
    [address setPostalCode:[self getString:@"PostalCode" from:addressDict]];
    [address setStateIso:[self getString:@"StateIso" from:addressDict]];
    [address setComment:[self getString:@"Comment" from:addressDict]];
    [address setAddressId:[self getLong:@"ID" from:addressDict]];
    [address setIsDefault:[self getBool:@"IsDefault" from:addressDict]];
    [address setTitle:[self getString:@"Title" from:addressDict]];
    return address;
}

/*
 ToDoV2:
 ignored ProfileImage & ProfileImageSize
 */
- (NSMutableArray*)parseFriendsResponse:(NSDictionary*)dictionary {
    NSMutableArray *array = [NSMutableArray new];
    NSArray *items = [self getArray:@"Items" from:dictionary];
    if (items == nil) return array;
    
    for (NSDictionary *friendDict in items) {
        Friend *friend = [Friend new];
        [friend setUserId:[self getString:@"DestWalletId" from:friendDict]];
        [friend setFullName:[self getString:@"FullName" from:friendDict]];
        [friend setRelationType:[self getInt:@"RelationType" from:friendDict]];
        [array addObject:friend];
    }
    return array;
}

/*
 ToDoV2:
 ignored ProfileImage & ProfileImageSize
 */
- (Customer*)parseCustomer:(id)resultObject {
    NSDictionary *dict = [self getDictionary:@"d" from:resultObject];
    Address *address = [self parseAddress:dict];
    Customer *customer = [Customer new];
    [customer setAddress:address];
    [customer setCellNumber:[self getString:@"CellNumber" from:dict]];
    [customer setCustomerNumber:[self getString:@"CustomerNumber" from:dict]];
    [customer setDateOfBirth:[self getReadableDate:@"DateOfBirth" from:dict]];
    [customer setEmail:[self getString:@"EmailAddress" from:dict]];
    [customer setFirstName:[self getString:@"FirstName" from:dict]];
    [customer setLastName:[self getString:@"LastName" from:dict]];
    [customer setPersonalNumber:[self getString:@"PersonalNumber" from:dict]];
    [customer setPhone:[self getString:@"PhoneNumber" from:dict]];
    [customer setRegistrationDate:[self getReadableDate:@"RegistrationDate" from:dict]];
    return customer;
}

- (NSMutableArray*)parseShippingAddresses:(id)resultObject {
    NSArray *result = [self getArray:@"d" from:resultObject];
    NSMutableArray *addressesArray = [[NSMutableArray alloc] init];
    if (result != nil) {
        for (NSDictionary *addressDict in result) {
            ShippingAddress *address = [self parseShippingAddress:addressDict];
            [addressesArray addObject:address];
        }
    }
    return addressesArray;
}

@end
