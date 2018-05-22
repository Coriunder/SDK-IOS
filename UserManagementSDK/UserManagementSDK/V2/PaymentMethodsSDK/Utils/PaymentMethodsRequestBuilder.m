//
//  PaymentMethodsRequestBuilder.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods designed to prepare
//  NSDictionary to send with requests to PaymentMethods service

#import "PaymentMethodsRequestBuilder.h"

@implementation PaymentMethodsRequestBuilder

- (NSDictionary*)buildJsonForDeletePm:(long)cardId {
    return @{ @"pmid": @(cardId), };
}

- (NSDictionary*)buildJsonForGetPm:(long)cardId {
    return @{ @"pmid": @(cardId), };
}

- (NSDictionary*)buildJsonForLinkPm:(NSString*)accountValue birthDate:(NSDate*)bDate
                     personalNumber:(NSString*)personalNumber phoneNumber:(NSString*)phoneNumber {
    // Parse date to server applicable format
    if (bDate == nil) bDate = [NSDate date];
    NSString *bDateString = [NSString stringWithFormat:@"/Date(%0.0f)/",[bDate timeIntervalSince1970]*1000];
    NSDictionary *params = @{ @"AccountValue1": [self getNonNilValueForString:accountValue],
                              @"DateOfBirth": [self getNonNilValueForString:bDateString],
                              @"PersonalNumber": [self getNonNilValueForString:personalNumber],
                              @"PhoneNumber": [self getNonNilValueForString:phoneNumber], };
    return @{ @"data": params, };
}

- (NSDictionary*)buildJsonForLoadPm:(double)amount currencyIso:(NSString*)currencyIso paymentMethodId:(long)paymentMethodId
                            pinCode:(NSString*)pinCode referenceCode:(NSString*)referenceCode {
    NSDictionary *params = @{ @"Amount": @(amount),
                              @"CurrencyIso": [self getNonNilValueForString:currencyIso],
                              @"PaymentMethodID": @(paymentMethodId),
                              @"PinCode": [self getNonNilValueForString:pinCode],
                              @"ReferenceCode": [self getNonNilValueForString:referenceCode], };
    return @{ @"data": params, };
}

- (NSDictionary*)buildJsonForRequestPhysicalPm:(NSString*)providerID addressLine1:(NSString*)addressLine1
                                  addressLine2:(NSString*)addressLine2 city:(NSString*)city countryIso:(NSString*)countryIso
                                    postalCode:(NSString*)postalCode stateIso:(NSString*)stateIso {
    // Create address NSDictionary
    NSDictionary *address = @{ @"AddressLine1": [self getNonNilValueForString:addressLine1],
                               @"AddressLine2": [self getNonNilValueForString:addressLine2],
                               @"City": [self getNonNilValueForString:city],
                               @"CountryIso": [self getNonNilValueForString:countryIso],
                               @"PostalCode": [self getNonNilValueForString:postalCode],
                               @"StateIso": [self getNonNilValueForString:stateIso], };
    NSDictionary *data =    @{ @"Address": address,
                               @"ProviderID": [self getNonNilValueForString:providerID], };
    return @{ @"data": data, };
}

- (NSDictionary*)buildJsonForSavePm:(NSDictionary*)methodData {
    if (methodData == nil) return nil;
    return @{ @"methodData": methodData, };
}

- (NSDictionary*)buildJsonForSavePms:(NSArray<PaymentMethod*>*)paymentMethods {
    if (paymentMethods == nil) return nil;
    
    // Create NSMutableArray with NSDictionary from NSArray with PaymentMethod objects
    NSMutableArray *cardsArray = [[NSMutableArray alloc]init];
    for (PaymentMethod *paymentMethod in paymentMethods) {
        NSDictionary *params = [self buildCardJson:paymentMethod isNew:false];
        if (params == nil) return nil;
        [cardsArray addObject:params];
    }
    return @{ @"data": cardsArray, };
}

/*
 ToDoV2:
 @"IsDefault": @(paymentMethod.isDefault), //[NSNumber numberWithBool:isDefault]
 not taken from android: NSString* accountValue1 = isNew ? paymentMethod.accountValue1 : nil;
 */
- (NSDictionary*)buildCardJson:(PaymentMethod*)paymentMethod isNew:(BOOL)isNew {
    if (paymentMethod == nil || paymentMethod.expirationDate == nil) return nil;
    
    // Parse date to server applicable format
    NSString *expDateString = [NSString stringWithFormat:@"/Date(%0.0f)/",[paymentMethod.expirationDate timeIntervalSince1970]*1000];
    long pmId = isNew ? 0 : paymentMethod.paymentMethodId;
    
    // Create billingAddress NSDictionary
    NSDictionary *billingAddress = @{ @"AddressLine1": [self getNonNilValueForString:paymentMethod.address.address1],
                                      @"AddressLine2": [self getNonNilValueForString:paymentMethod.address.address2],
                                      @"City": [self getNonNilValueForString:paymentMethod.address.city],
                                      @"CountryIso": [self getNonNilValueForString:paymentMethod.address.countryIso],
                                      @"PostalCode": [self getNonNilValueForString:paymentMethod.address.postalCode],
                                      @"StateIso": [self getNonNilValueForString:paymentMethod.address.stateIso], };
    
    return @{ @"AccountValue1": [self getNonNilValueForString:paymentMethod.accountValue1],
              @"AccountValue2": [self getNonNilValueForString:paymentMethod.accountValue2],
              @"Address": billingAddress,
              @"Display": [self getNonNilValueForString:paymentMethod.display],
              @"ExpirationDate": [self getNonNilValueForString:expDateString],
              @"ID": @(pmId),
              @"Icon": [self getNonNilValueForString:paymentMethod.iconURL],
              @"IsDefault": @(paymentMethod.isDefault),
              @"IssuerCountryIsoCode": [self getNonNilValueForString:paymentMethod.issuerCountryIsoCode],
              @"Last4Digits": [self getNonNilValueForString:paymentMethod.last4Digits],
              @"OwnerName": [self getNonNilValueForString:paymentMethod.ownerName],
              @"PaymentMethodGroupKey": [self getNonNilValueForString:paymentMethod.paymentMethodGroupKey],
              @"PaymentMethodKey": [self getNonNilValueForString:paymentMethod.paymentMethodKey],
              @"Title": [self getNonNilValueForString:paymentMethod.title], };
}

/**
 * Method to get non-nil NSString object
 * @param string NSString which shouldn't be nil
 */
-(NSString*)getNonNilValueForString:(NSString*)string {
    return (string == nil) ? @"" : string;
}

@end