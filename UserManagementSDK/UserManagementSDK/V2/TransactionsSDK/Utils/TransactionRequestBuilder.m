//
//  TransactionRequestBuilder.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods designed to prepare
//  NSDictionaryto send with requests to Transactions service

#import "TransactionRequestBuilder.h"

@implementation TransactionRequestBuilder

- (NSDictionary*)buildJsonForGet:(long)transactionId {
    return @{ @"transactionId": @(transactionId), };
}

- (NSDictionary*)buildJsonForLookup:(NSDate*)date amount:(double)amount last4cc:(NSString*)last4cc {
    if (date == nil) date = [NSDate date];
    NSString *dateString = [NSString stringWithFormat:@"/Date(%0.0f)/",[date timeIntervalSince1970]*1000];
    return @{ @"transDate": [self getNonNilValueForString:dateString],
              @"amount": @(amount),
              @"last4cc": [self getNonNilValueForString:last4cc], };
}

/*
 ToDoV2:
 Not all params used
 */
- (NSDictionary*)buildJsonForProcess:(NSString*)pinCode addressId:(long)addressId
                          cartCookie:(NSString*)cartCookie paymentMethodId:(long)paymentMethodId {
    NSDictionary *data = @{ @"PinCode": [self getNonNilValueForString:pinCode],
                            @"ShippingAddressId": @(addressId),
                            @"ShopCartCookie": [self getNonNilValueForString:cartCookie],
                            @"StoredPaymentMethodId": @(paymentMethodId), };
    NSDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:data forKey:@"data"];
    return params;
}

/*
 ToDoV2:
 What types should TransactionStatus have
 */
- (NSDictionary*)buildJsonForSearch:(double)amountFrom amountTo:(double)amountTo currencyIso:(NSString*)currencyIso
                           dateFrom:(NSDate*)dateFrom dateTo:(NSDate*)dateTo idFrom:(long)idFrom idTo:(long)idTo
                       loadMerchant:(BOOL)loadMerchant loadPayer:(BOOL)loadPayer loadPayment:(BOOL)loadPayment
                  transactionStatus:(int)transType page:(int)page pageSize:(int)pageSize {
    
    // Parse dates to server applicable format
    if (dateFrom == nil) dateFrom = [NSDate date];
    if (dateTo == nil) dateTo = [NSDate date];
    NSString *dateFromString = [NSString stringWithFormat:@"/Date(%0.0f)/",[dateFrom timeIntervalSince1970]*1000];
    NSString *dateToString = [NSString stringWithFormat:@"/Date(%0.0f)/",[dateTo timeIntervalSince1970]*1000];
    // Create filters NSDictionary
    NSDictionary *filters =     @{ @"AmountFrom": @(amountFrom),
                                   @"AmountTo": @(amountTo),
                                   @"CurrencyIso": [self getNonNilValueForString:currencyIso],
                                   @"DateFrom": [self getNonNilValueForString:dateFromString],
                                   @"DateTo": [self getNonNilValueForString:dateToString],
                                   @"IDFrom": @(idFrom),
                                   @"IDTo": @(idTo), };
    // Create loadOptions NSDictionary
    NSDictionary *loadOptions = @{ @"LoadMerchant": @(loadMerchant),
                                   @"LoadPayer": @(loadPayer),
                                   @"LoadPayment": @(loadPayment),
                                   @"TransType": @(transType), };
    // Create sortAndPage NSDictionary
    NSDictionary *sortAndPage = @{ @"PageNumber": @(page),
                                   @"PageSize": @(pageSize), };
    return @{ @"filters": filters,
              @"loadOptions": loadOptions,
              @"sortAndPage": sortAndPage, };
}

/**
 * Method to get non-nil NSString object
 * @param string NSString which shouldn't be nil
 */
-(NSString*)getNonNilValueForString:(NSString*)string {
    return (string == nil) ? @"" : string;
}

@end