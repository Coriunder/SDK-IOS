//
//  BalanceRequestBuilder.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods designed to prepare
//  NSDictionary to send with requests to Balance service

#import <Foundation/Foundation.h>

@interface BalanceRequestBuilder : NSObject

/**
 * Prepare NSDictionary for GetRequest request
 * @param requestId id of the request which info should be loaded
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForGetRequest:(long)requestId;

/**
 * Prepare NSDictionary for GetRequests request
 * @param currencyIso ISO code for currency which requests should be returned for
 * @param paymentMethodId id of the payment method
 * @param page number of the page with results, minimum value is 0
 * @param pageSize results amount per page
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForGetRequests:(NSString*)currencyIso paymentMethodId:(long)paymentMethodId
                                    page:(int)page pageSize:(int)pageSize;

/**
 * Prepare NSDictionary for GetRows request
 * @param currencyIso ISO code for currency which transactions should be returned for
 * @param paymentMethodId id of the payment method
 * @param page number of the page with results, minimum value is 0
 * @param pageSize results amount per page
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForGetRows:(NSString*)currencyIso paymentMethodId:(long)paymentMethodId
                                page:(int)page pageSize:(int)pageSize;

/**
 * Prepare NSDictionary for GetTotal request
 * @param currencyIso ISO code for currency which balances should be returned for
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForGetTotal:(NSString*)currencyIso;

/**
 * Prepare NSDictionary for ReplyRequest request
 * @param requestId id of the request which has to approved or declined
 * @param approve defines whether request has to approved or declined
 * @param pinCode current user pin code
 * @param text comment for transaction
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForReplyRequest:(long)requestId approve:(BOOL)approve
                                  pinCode:(NSString*)pinCode text:(NSString*)text;

/**
 * Prepare NSDictionary for RequestAmount request
 * @param userId id of the user who should receive the request
 * @param amount amount which has to be requested
 * @param currencyIso ISO code of the currency for the request
 * @param text comment for request
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForRequestAmount:(NSString*)userId amount:(double)amount
                               currencyIso:(NSString*)currencyIso text:(NSString*)text;

/**
 * Prepare NSDictionary for TransferAmount request
 * @param userId id of the user who should receive the amount
 * @param amount amount which has to be sent
 * @param currencyIso ISO code of the currency for the transfer
 * @param pinCode current user pin code
 * @param text comment for transfer
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForTransferAmount:(NSString*)userId amount:(double)amount
                                currencyIso:(NSString*)currencyIso pinCode:(NSString*)pinCode text:(NSString*)text;

@end