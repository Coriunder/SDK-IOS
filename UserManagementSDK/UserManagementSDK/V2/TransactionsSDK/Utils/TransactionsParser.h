//
//  TransactionsParser.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Parser methods for Transactions services

#import "BaseParser.h"
#import "Transaction.h"
#import "TransactionLookup.h"

@interface TransactionsParser : BaseParser

/**
 * Method to parse NSDictionary to Transaction object
 * @param transactionDict NSDictionary to parse
 * @return Transaction object
 */
- (Transaction*)parseTransaction:(NSDictionary*)transactionDict;

/**
 * Method to parse result to NSMutableArray containing TransactionLookup objects
 * @param resultObject result to parse
 * @return NSMutableArray containing TransactionLookup objects
 */
- (NSMutableArray*)parseTransactionLookup:(id)resultObject;

/**
 * Method to parse result to ArrayList containing Transaction objects
 * @param resultObject result to parse
 * @return NSMutableArray containing Transaction objects
 */
- (NSMutableArray*)parseSearch:(id)resultObject;

@end
