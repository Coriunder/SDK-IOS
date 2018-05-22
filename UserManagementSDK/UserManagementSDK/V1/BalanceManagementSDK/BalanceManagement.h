//
//  BalanceManagement.h
//  UserManagementSDK
//
//  Created by Lev T on 03/02/16.
//  Copyright © 2016 Sapdan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkManagerOld.h"
#import "RequestItemOld.h"

@interface BalanceManagement : NetworkManagerOld

+ (BalanceManagement *)getInstance;

/**
 * Get total user balance for currency.
 *
 * @param
 * - currencyIso - ISO code for currency which the balance should be returned for, can't be empty or nil
 * - includePending - defines whether any pending amounts should be included (YES) or only real balance
 *   should be returned (NO)
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSString *balance - user balance for currency (0 in case request was NOT successful)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)getUserBalanceForCurrency:(NSString*)currencyIso includePending:(BOOL)includePending callback:(void (^)(bool success, NSString *balance, NSString* message))callback;

/**
 * Get transactions history for currency.
 *
 * @param
 * - currencyIso - ISO code for currency which transactions should be returned for, can't be empty or nil
 * - page - number of the page with results, minimum value is 0
 * - pageSize - results amount per page
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSMutableArray *balanceRows - array containing BalanceItem objects (nil in case request was NOT successful)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)getTransactionsHistoryWithCurrency:(NSString*)currencyIso page:(int)page pageSize:(int)pageSize callback:(void (^)(bool success, NSMutableArray *balanceRows, NSString* message))callback;

/**
 * Get exact request info.
 *
 * @param
 * - requestId - id of request which info should be loaded
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - RequestItem *request - RequestItem objects (nil in case request was NOT successful)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)getRequestWithId:(NSInteger)requestId callback:(void (^)(bool success, RequestItemOld *request, NSString* message))callback;

/**
 * Get requests history for currency.
 *
 * @param
 * - currencyIso - ISO code for currency which requests should be returned for, can't be empty or nil
 * - page - number of the page with results, minimum value is 0
 * - pageSize - results amount per page
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSMutableArray *requests - array containing RequestItem objects (nil in case request was NOT successful)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)getRequestsWithCurrency:(NSString*)currencyIso page:(int)page pageSize:(int)pageSize callback:(void (^)(bool success, NSMutableArray *requests, NSString* message))callback;

/**
 * Reply transaction request
 *
 * @param
 * - requestId - id of the request which has to approved or declined
 * - approve - defines whether request has to approved (value YES) or declined (value NO)
 * - pinCode - current user pincode, can't be empty or nil
 * - text - comment for transaction
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)replyRequest:(NSInteger)requestId approve:(BOOL)approve pinCode:(NSString *)pinCode text:(NSString *)text callback:(void (^)(bool success, NSString* message))callback;

/**
 * Send transaction request
 *
 * @param
 * - userId - id of the user who should receive the request, can't be empty or nil
 * - amount - amount which has to be requested
 * - currencyIso - ISO code for currency in which request should be made, can't be empty or nil
 * - text - comment for request
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)requestAmountFromUser:(NSString *)userId amount:(float)amount currencyIso:(NSString *)currencyIso text:(NSString *)text callback:(void (^)(bool success, NSString* message))callback;

/**
 * Transfer amount to another user
 *
 * @param
 * - userId - id of the user who should receive the amount, can't be empty or nil
 * - amount - amount which has to be sent
 * - currencyIso - ISO code for currency in which transfer should be made, can't be empty or nil
 * - text - comment for transfer
 * - pinCode - current user pincode, can't be empty or nil
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)transferAmountToUser:(NSString *)userId amount:(float)amount currencyIso:(NSString *)currencyIso text:(NSString *)text pinCode:(NSString *)pinCode callback:(void (^)(bool success, NSString* message))callback;

@end