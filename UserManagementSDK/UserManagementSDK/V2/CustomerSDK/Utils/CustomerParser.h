//
//  CustomerParser.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Parser methods for Customer services

#import "BaseParser.h"
#import "Customer.h"
#import "ShippingAddress.h"
#import "Friend.h"

@interface CustomerParser : BaseParser

/**
 * Method to parse result to ShippingAddress object
 * @param addressDict result to parse
 * @return ShippingAddress object
 */
- (ShippingAddress*)parseShippingAddress:(NSDictionary*)addressDict;

/**
 * Method to parse result to NSMutableArray containing Friend objects
 * @param dictionary result to parse
 * @return NSMutableArray containing Friend objects
 */
- (NSMutableArray*)parseFriendsResponse:(NSDictionary*)dictionary;

/**
 * Method to parse result to Customer object
 * @param resultObject result to parse
 * @return Customer object
 */
- (Customer*)parseCustomer:(id)resultObject;

/**
 * Method to parse result to NSMutableArray containing ShippingAddress objects
 * @param resultObject result to parse
 * @return NSMutableArray containing ShippingAddress objects
 */
- (NSMutableArray*)parseShippingAddresses:(id)resultObject;

@end
