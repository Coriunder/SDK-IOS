//
//  BalanceSDK.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods to perform requests to the Balance service

#import "Coriunder.h"
#import "ServiceResult.h"
#import "Request.h"
#import "BalanceRow.h"
#import "BalanceTotal.h"

@interface BalanceSDK : Coriunder

/**
 * Get instance for BalanceSDK class.
 * In case there is no current instance, a new one will be created
 * @return BalanceSDK instance
 */
+ (BalanceSDK*)getInstance;



/**
 * Get info about exact request
 *
 * @param requestId id of the request which info should be loaded
 * @param callback will be called after request completion
 */
- (void)getRequestWithId:(long)requestId callback:(void (^)(BOOL success, Request *request, NSString* message))callback;

/**
 * Get requests' history
 *
 * @param currencyIso ISO code for currency which requests should be returned for
 * @param paymentMethodId id of the payment method
 * @param page number of the page with results, minimum value is 0
 * @param pageSize results amount per page
 * @param callback will be called after request completion
 */
- (void)getRequestsWithCurrency:(NSString*)currencyIso paymentMethodId:(long)paymentMethodId page:(int)page pageSize:(int)pageSize callback:(void (^)(BOOL success, NSMutableArray<Request*> *requests, NSString* message))callback;

/**
 * Get transactions' history
 *
 * @param currencyIso ISO code for currency which transactions should be returned for
 * @param paymentMethodId id of the payment method
 * @param page number of the page with results, minimum value is 0
 * @param pageSize results amount per page
 * @param callback will be called after request completion
 */
- (void)getTransactionsHistoryWithCurrency:(NSString*)currencyIso paymentMethodId:(long)paymentMethodId page:(int)page pageSize:(int)pageSize callback:(void (^)(BOOL success, NSMutableArray<BalanceRow*> *balanceRows, NSString* message))callback;

/**
 * Get list of user balances
 *
 * @param currencyIso ISO code for currency which balances should be returned for
 * @param callback will be called after request completion
 */
- (void)getTotalForCurrency:(NSString*)currencyIso callback:(void (^)(BOOL success, NSMutableArray<BalanceTotal*> *balances, NSString* message))callback;

/**
 * Reply transaction request
 *
 * @param requestId id of the request which has to approved or declined
 * @param approve defines whether request has to approved or declined
 * @param pinCode current user pin code
 * @param text comment for transaction
 * @param callback will be called after request completion
 */
- (void)replyRequest:(long)requestId approve:(BOOL)approve pinCode:(NSString*)pinCode text:(NSString*)text callback:(void (^)(BOOL success, ServiceResult *result, NSString* message))callback;

/**
 * Send transaction request
 *
 * @param userId id of the user who should receive the request
 * @param amount amount which has to be requested
 * @param currencyIso ISO code of the currency for the request
 * @param text comment for request
 * @param callback will be called after request completion
 */
- (void)requestAmountFromUser:(NSString*)userId amount:(double)amount currencyIso:(NSString*)currencyIso text:(NSString*)text callback:(void (^)(BOOL success, ServiceResult *result, NSString* message))callback;

/**
 * Transfer amount to another user
 *
 * @param userId id of the user who should receive the amount
 * @param amount amount which has to be sent
 * @param currencyIso ISO code of the currency for the transfer
 * @param pinCode current user pin code
 * @param text comment for transfer
 * @param callback will be called after request completion
 */
- (void)transferAmountToUser:(NSString*)userId amount:(double)amount currencyIso:(NSString*)currencyIso pinCode:(NSString*)pinCode text:(NSString*)text callback:(void (^)(BOOL success, ServiceResult *result, NSString* message))callback;

@end
