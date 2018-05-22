//
//  TransactionRequestBuilder.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods designed to prepare
//  NSDictionaryto send with requests to Transactions service

#import <Foundation/Foundation.h>

@interface TransactionRequestBuilder : NSObject

/**
 * Prepare NSDictionary for GetRequest
 * @param transactionId id of the transaction which info has to be loaded
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForGet:(long)transactionId;

/**
 * Prepare NSDictionary for Lookup request
 * @param date date of transaction
 * @param amount amount of transaction
 * @param last4cc last 4 symbols for the payment method used to pay for transaction
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForLookup:(NSDate*)date amount:(double)amount last4cc:(NSString*)last4cc;

/**
 * Prepare NSDictionary for ProcessTransaction request
 * @param pinCode current user's pin code
 * @param addressId id of the shipping address, which has to be used to process the cart
 * @param cartCookie cookie of the cart which has to be processed
 * @param paymentMethodId id of the payment method, which has to be used to process the cart
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForProcess:(NSString*)pinCode addressId:(long)addressId
                          cartCookie:(NSString*)cartCookie paymentMethodId:(long)paymentMethodId;

/**
 * Prepare NSDictionary for Search request
 * @param amountFrom min transaction amount
 * @param amountTo max transaction amount
 * @param currencyIso currency of transaction
 * @param dateFrom min transaction date
 * @param dateTo max transaction date
 * @param idFrom min transaction id
 * @param idTo max transaction id
 * @param loadMerchant sets whether merchant info needs to be included in the response
 * @param loadPayer sets whether payer info needs to be included in the response
 * @param loadPayment sets whether payment info needs to be included in the response
 * @param transType transaction type
 * @param page number of the page with results, minimum value is 1
 * @param pageSize results' amount per page
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForSearch:(double)amountFrom amountTo:(double)amountTo currencyIso:(NSString*)currencyIso
                           dateFrom:(NSDate*)dateFrom dateTo:(NSDate*)dateTo idFrom:(long)idFrom idTo:(long)idTo
                       loadMerchant:(BOOL)loadMerchant loadPayer:(BOOL)loadPayer loadPayment:(BOOL)loadPayment
                  transactionStatus:(int)transType page:(int)page pageSize:(int)pageSize;

@end