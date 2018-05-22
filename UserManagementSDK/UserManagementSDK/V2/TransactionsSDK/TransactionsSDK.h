//
//  TransactionsSDK.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods to perform requests to the Transactions service

#import "Coriunder.h"
#import "ServiceResult.h"
#import "Transaction.h"
#import "TransactionLookup.h"

@interface TransactionsSDK : Coriunder

/**
 * Get instance for TransactionsSDK class.
 * In case there is no current instance, a new one will be created
 * @return TransactionsSDK instance
 */
+ (TransactionsSDK*)getInstance;



/**
 * Get full info about exact transaction
 *
 * @param transactionId id of the transaction which info has to be loaded
 * @param callback will be called after request completion
 */
- (void)getTransactionWithId:(long)transactionId callback:(void (^)(BOOL success, Transaction *transaction, NSString* message))callback;

/**
 * Lookup transaction. Gives short info about transactions which match search terms
 *
 * @param date date of transaction
 * @param amount amount of transaction
 * @param last4cc last 4 symbols for the payment method used to pay for transaction
 * @param callback will be called after request completion
 */
- (void)lookupTransactionWithDate:(NSDate*)date amount:(double)amount last4cc:(NSString*)last4cc callback:(void (^)(BOOL success, NSMutableArray<TransactionLookup*> *result, NSString* message))callback;

/**
 * Process exact cart. Should be called separately for each cart.
 *
 * @param pinCode current user's pin code
 * @param addressId id of the shipping address, which has to be used to process the cart
 * @param cartCookie cookie of the cart which has to be processed
 * @param paymentMethodId id of the payment method, which has to be used to process the cart
 * @param callback will be called after request completion
 */
- (void)processCartWithPinCode:(NSString*)pinCode addressId:(long)addressId cartCookie:(NSString*)cartCookie paymentMethodId:(long)paymentMethodId callback:(void (^)(BOOL success, ServiceResult *result, NSString* message))callback;

/**
 * Search for transactions. Gives full info about transactions which match search terms
 *
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
 * @param callback will be called after request completion
 */
- (void)searchTransactionWithAmountFrom:(double)amountFrom amountTo:(double)amountTo currencyIso:(NSString*)currencyIso dateFrom:(NSDate*)dateFrom dateTo:(NSDate*)dateTo idFrom:(long)idFrom idTo:(long)idTo loadMerchant:(BOOL)loadMerchant loadPayer:(BOOL)loadPayer loadPayment:(BOOL)loadPayment transactionStatus:(int)transType page:(int)page pageSize:(int)pageSize callback:(void (^)(BOOL success, NSMutableArray<Transaction*> *result, NSString* message))callback;

@end
