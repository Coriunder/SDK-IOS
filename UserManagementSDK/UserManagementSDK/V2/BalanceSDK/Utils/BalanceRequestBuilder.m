//
//  BalanceRequestBuilder.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods designed to prepare
//  NSDictionary to send with requests to Balance service

#import "BalanceRequestBuilder.h"

@implementation BalanceRequestBuilder

- (NSDictionary*)buildJsonForGetRequest:(long)requestId {
    return @{ @"requestId":@(requestId), };
}

- (NSDictionary*)buildJsonForGetRequests:(NSString*)currencyIso paymentMethodId:(long)paymentMethodId
                                    page:(int)page pageSize:(int)pageSize {
    // Create filters NSDictionary
    NSDictionary *filters =     @{ @"CurrencyIso": [self getNonNilValueForString:currencyIso],
                                   @"StoredPaymentMethodID": @(paymentMethodId), };
    // Create sortAndPage NSDictionary
    NSDictionary *sortAndPage = @{ @"PageNumber": @(page),
                                   @"PageSize": @(pageSize), };
    return @{ @"filters": filters,
              @"sortAndPage": sortAndPage, };
}

- (NSDictionary*)buildJsonForGetRows:(NSString*)currencyIso paymentMethodId:(long)paymentMethodId
                                page:(int)page pageSize:(int)pageSize {
    // Create filters NSDictionary
    NSDictionary *filters =     @{ @"CurrencyIso": [self getNonNilValueForString:currencyIso],
                                   @"StoredPaymentMethodID": @(paymentMethodId), };
    // Create sortAndPage NSDictionary
    NSDictionary *sortAndPage = @{ @"PageNumber": @(page),
                                   @"PageSize": @(pageSize), };
    return @{ @"filters": filters,
              @"sortAndPage": sortAndPage, };
}

- (NSDictionary*)buildJsonForGetTotal:(NSString*)currencyIso {
    return @{ @"currencyIsoCode":[self getNonNilValueForString:currencyIso], };
}

- (NSDictionary*)buildJsonForReplyRequest:(long)requestId approve:(BOOL)approve
                                  pinCode:(NSString*)pinCode text:(NSString*)text {
    return @{ @"requestId": @(requestId),
              @"approve": @(approve),
              @"pinCode": [self getNonNilValueForString:pinCode],
              @"text": [self getNonNilValueForString:text], };
}

- (NSDictionary*)buildJsonForRequestAmount:(NSString*)userId amount:(double)amount
                               currencyIso:(NSString*)currencyIso text:(NSString*)text {
    return @{ @"destAcocuntId": [self getNonNilValueForString:userId],
              @"amount": @(amount),
              @"currencyIso": [self getNonNilValueForString:currencyIso],
              @"text": [self getNonNilValueForString:text], };
}

- (NSDictionary*)buildJsonForTransferAmount:(NSString*)userId amount:(double)amount
                                currencyIso:(NSString*)currencyIso pinCode:(NSString*)pinCode text:(NSString*)text {
    return @{ @"destAcocuntId": [self getNonNilValueForString:userId],
              @"amount": @(amount),
              @"currencyIso": [self getNonNilValueForString:currencyIso],
              @"pinCode": [self getNonNilValueForString:pinCode],
              @"text": [self getNonNilValueForString:text], };
}

/**
 * Method to get non-nil NSString object
 * @param string NSString which shouldn't be nil
 */
-(NSString*)getNonNilValueForString:(NSString*)string {
    return (string == nil) ? @"" : string;
}

@end
