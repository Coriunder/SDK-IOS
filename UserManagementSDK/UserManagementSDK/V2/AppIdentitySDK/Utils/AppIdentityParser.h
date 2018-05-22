//
//  AppIdentityParser.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Parser methods for AppIdentity services

#import "BaseParser.h"
#import "Identity.h"
#import "MerchantGroup.h"

@interface AppIdentityParser : BaseParser

/**
 * Method to parse result to Identity object
 * @param resultObject result to parse
 * @return Identity object
 */
- (Identity*)parseIdentity:(id)resultObject;

/**
 * Method to parse result to NSMutableArray containing MerchantGroup objects
 * @param resultObject result to parse
 * @return NSMutableArray containing MerchantGroup objects
 */
- (NSMutableArray*)parseMerchantGroups:(id)resultObject;

@end
