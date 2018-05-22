//
//  ShopParser.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Parser methods for Shop services

#import "BaseParser.h"
#import "Cart.h"
#import "Shop.h"

@interface ShopParser : BaseParser

/**
 * Method to parse NSDictionary to Cart object
 * @param cartDictionary NSDictionary to parse
 * @return Cart object
 */
- (Cart*)parseCart:(NSDictionary*)cartDictionary;

/**
 * Method to parse NSArray to NSMutableArray containing CartItem objects
 * @param items NSArray to parse
 * @return NSMutableArray containing CartItem objects
 */
- (NSMutableArray*)parseCartItems:(NSArray*)items;

/**
 * Method to parse NSDictionary to Product object
 * @param productDictionary NSDictionary to parse
 * @return Product object
 */
- (Product*)parseProduct:(NSDictionary*)productDictionary;

/**
 * Method to parse NSDictionary to Shop object
 * @param shopDict NSDictionary to parse
 * @return Shop object
 */
- (Shop*)parseShop:(NSDictionary*)shopDict;

/**
 * Method to parse result to NSMutableArray containing Cart objects
 * @param resultObject result to parse
 * @return NSMutableArray containing Cart objects
 */
- (NSMutableArray*)parseActiveCarts:(id)resultObject;

/**
 * Method to parse result to NSMutableArray containing ProductCategory objects
 * @param resultObject result to parse
 * @return NSMutableArray containing ProductCategory objects
 */
- (NSMutableArray*)parseCategories:(id)resultObject;

/**
 * Method to parse result to NSMutableArray containing Merchant objects
 * @param resultObject result to parse
 * @return NSMutableArray containing Merchant objects
 */
- (NSMutableArray*)parseMerchants:(id)resultObject;

/**
 * Method to parse result to NSMutableArray containing Product objects
 * @param resultObject result to parse
 * @return NSMutableArray containing Product objects
 */
- (NSMutableArray*)parseProducts:(id)resultObject;

/**
 * Method to parse result to NSMutableArray containing Shop objects
 * @param resultObject result to parse
 * @return NSMutableArray containing Shop objects
 */
- (NSMutableArray*)parseShops:(id)resultObject;

@end
