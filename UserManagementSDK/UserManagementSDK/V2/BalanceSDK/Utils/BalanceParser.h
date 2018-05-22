//
//  BalanceParser.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Parser methods for Balance services

#import "BaseParser.h"
#import "Request.h"
#import "BalanceRow.h"
#import "BalanceTotal.h"

@interface BalanceParser : BaseParser

/**
 * Method to parse NSDictionary to Request object
 * @param dictionary NSDictionary to parse
 * @return Request object
 */
- (Request*)parseRequest:(NSDictionary*)dictionary;

/**
 * Method to parse NSDictionary to NSMutableArray containing Request objects
 * @param resultObject NSDictionary to parse
 * @return NSMutableArray containing Request objects
 */
- (NSMutableArray*)parseRequests:(id)resultObject;

/**
 * Method to parse NSDictionary to NSMutableArray containing BalanceRow objects
 * @param resultObject NSDictionary to parse
 * @return NSMutableArray containing BalanceRow objects
 */
- (NSMutableArray*)parseRows:(id)resultObject;

/**
 * Method to parse NSDictionary to NSMutableArray containing BalanceTotal objects
 * @param resultObject NSDictionary to parse
 * @return NSMutableArray containing BalanceTotal objects
 */
- (NSMutableArray*)parseTotal:(id)resultObject;

@end
