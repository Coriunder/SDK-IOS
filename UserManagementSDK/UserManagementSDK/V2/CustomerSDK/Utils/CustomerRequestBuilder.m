//
//  CustomerRequestBuilder.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods designed to prepare
//  NSDictionary to send with requests to Customer service

#import "CustomerRequestBuilder.h"

@implementation CustomerRequestBuilder

- (NSDictionary*)buildJsonForGetImage:(NSString*)userId asRaw:(BOOL)asRaw {
    return @{ @"walletId": [self getNonNilValueForString:userId],
              @"asRaw": @(asRaw), };
}

/*
 ToDoV2:
 ShippingAddresses part ignored
 StoredPaymentMethods part ignored
 Many params of the info part ignored
 */
- (NSDictionary*)buildJsonForRegisterCustomer:(NSString*)password pinCode:(NSString*)pinCode email:(NSString*)email
                                    firstName:(NSString*)firstName lastName:(NSString*)lastName appToken:(NSString*)appToken {
    // Create info NSMutableDictionary
    NSMutableDictionary *info = [NSMutableDictionary new];
    [info setObject:[self getNonNilValueForString:email] forKey:@"EmailAddress"];
    [info setObject:[self getNonNilValueForString:firstName] forKey:@"FirstName"];
    [info setObject:[self getNonNilValueForString:lastName] forKey:@"LastName"];
    
    NSDictionary *data = @{ @"ApplicationToken": appToken,
                            @"Password": [self getNonNilValueForString:password],
                            @"PinCode": [self getNonNilValueForString:pinCode],
                            @"info": info, };
    
    return @{ @"data": data, };
}

- (NSDictionary*)buildJsonForSaveCustomer:(NSString*)firstName lastName:(NSString*)lastName email:(NSString*)email
                             addressLine1:(NSString*)addressLine1 addressLine2:(NSString*)addressLine2 city:(NSString*)city
                               countryIso:(NSString*)countryIso postalCode:(NSString*)postalCode stateIso:(NSString*)stateIso
                               cellNumber:(NSString*)cellNumber birthDate:(NSDate*)birthDate personalNumber:(NSString*)personalNumber
                              phoneNumber:(NSString*)phoneNumber profileImage:(UIImage*)profileImage {
    
    if (birthDate == nil) birthDate = [NSDate date];
    NSString *birthDateString = [NSString stringWithFormat:@"/Date(%0.0f)/",[birthDate timeIntervalSince1970]*1000];
    
    // Create info NSMutableDictionary
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:[self getNonNilValueForString:addressLine1] forKey:@"AddressLine1"];
    [params setObject:[self getNonNilValueForString:addressLine2] forKey:@"AddressLine2"];
    [params setObject:[self getNonNilValueForString:city] forKey:@"City"];
    [params setObject:[self getNonNilValueForString:countryIso] forKey:@"CountryIso"];
    [params setObject:[self getNonNilValueForString:postalCode] forKey:@"PostalCode"];
    [params setObject:[self getNonNilValueForString:stateIso] forKey:@"StateIso"];
    [params setObject:[self getNonNilValueForString:cellNumber] forKey:@"CellNumber"];
    [params setObject:[self getNonNilValueForString:birthDateString] forKey:@"DateOfBirth"];
    [params setObject:[self getNonNilValueForString:email] forKey:@"EmailAddress"];
    [params setObject:[self getNonNilValueForString:firstName] forKey:@"FirstName"];
    [params setObject:[self getNonNilValueForString:lastName] forKey:@"LastName"];
    [params setObject:[self getNonNilValueForString:personalNumber] forKey:@"PersonalNumber"];
    [params setObject:[self getNonNilValueForString:phoneNumber] forKey:@"PhoneNumber"];
    
    // Encode image to add it to NSMutableDictionary
    if (profileImage) {
        UIImage *image = profileImage;
        NSData *data = UIImagePNGRepresentation(image);
        NSUInteger len = data.length;
        uint8_t *bytes = (uint8_t *)[data bytes];
        NSMutableString *result = [NSMutableString stringWithCapacity:len * 3];
        for (NSUInteger i = 0; i < len; i++) {
            if (i) [result appendString:@","];
            [result appendFormat:@"%d", bytes[i]];
        }
        NSArray *words = [result componentsSeparatedByString:@","];
        NSMutableArray *triples = [NSMutableArray new];
        for (NSUInteger i = 0; i < words.count; i ++) {
            [triples addObject:words[i]];
        }
        [params setObject:triples forKey:@"ProfileImage"];
    }
    
    return @{ @"info": params, };
}

- (NSDictionary*)buildJsonForFindFriend:(NSString*)nameOrId page:(int)page pageSize:(int)pageSize {
    // Create sortAndPage NSDictionary
    NSDictionary *sortAndPage = @{ @"PageNumber": @(page),
                                   @"PageSize": @(pageSize), };
    return @{ @"searchTerm": [self getNonNilValueForString:nameOrId],
              @"sortAndPage": sortAndPage, };
}

- (NSDictionary*)buildJsonForFriendRequest:(NSString*)friendId {
    return @{ @"destWalletId": [self getNonNilValueForString:friendId], };
}

- (NSDictionary*)buildJsonForGetFriendRequests:(NSString*)friendId {
    return @{ @"destWalletId": [self getNonNilValueForString:friendId], };
}

- (NSDictionary*)buildJsonForGetFriends:(NSString*)friendId {
    return @{ @"destWalletId": [self getNonNilValueForString:friendId], };
}

- (NSDictionary*)buildJsonForImportFb:(NSString*)accessToken {
    return @{ @"accessToken": [self getNonNilValueForString:accessToken], };
}

- (NSDictionary*)buildJsonForRemoveFriend:(NSString*)friendId {
    return @{ @"destWalletId": [self getNonNilValueForString:friendId], };
}

- (NSDictionary*)buildJsonForReplyRequest:(NSString*)friendId approve:(BOOL)approve {
    return @{ @"destWalletId": [self getNonNilValueForString:friendId],
              @"approve": @(approve), };
}

- (NSDictionary*)buildJsonForRelation:(int)relation withFriend:(NSString*)friendId {
    return @{ @"destWalletId": [self getNonNilValueForString:friendId],
              @"relationTypeKey": @(relation), };
}

- (NSDictionary*)buildJsonForDeleteAddress:(long)addressId {
    return @{ @"addressId":@(addressId), };
}

- (NSDictionary*)buildJsonForGetAddress:(long)addressId {
    return @{ @"addressId": @(addressId), };
}

- (NSDictionary*)buildJsonForSaveAddress:(NSDictionary*)params {
    if (params == nil) return nil;
    return @{ @"address": params, };
}

- (NSDictionary*)buildJsonForSaveAddresses:(NSArray<ShippingAddress*>*)shippingAddresses {
    if (shippingAddresses == nil) return nil;
    
    // Create NSMutableArray with NSDictionary from NSArray with ShippingAddress objects
    NSMutableArray *addressesArray = [[NSMutableArray alloc]init];
    for (ShippingAddress *address in shippingAddresses) {
        NSDictionary* params = [self buildAddressJson:address isNew:false];
        if (params == nil)  return nil;
        [addressesArray addObject:params];
    }
    
    return @{ @"data": addressesArray, };
}

- (NSDictionary*)buildAddressJson:(ShippingAddress*)address isNew:(BOOL)isNew {
    if (address == nil) return nil;
    long addressId = isNew ? 0 : address.addressId;
    return @{ @"AddressLine1": [self getNonNilValueForString:address.address1],
              @"AddressLine2": [self getNonNilValueForString:address.address2],
              @"City": [self getNonNilValueForString:address.city],
              @"CountryIso": [self getNonNilValueForString:address.countryIso],
              @"PostalCode": [self getNonNilValueForString:address.postalCode],
              @"StateIso": [self getNonNilValueForString:address.stateIso],
              @"Comment": [self getNonNilValueForString:address.comment],
              @"ID": @(addressId),
              @"IsDefault": @(address.isDefault),
              @"Title": [self getNonNilValueForString:address.title], };
}

/**
 * Method to get non-nil NSString object
 * @param string NSString which shouldn't be nil
 */
-(NSString*)getNonNilValueForString:(NSString*)string {
    return (string == nil) ? @"" : string;
}

@end