//
//  PaymentMethodsParser.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Parser methods for PaymentMethods services

#import "BaseParser.h"
#import "PaymentMethod.h"
#import "PaymentCardRootGroup.h"

@interface PaymentMethodsParser : BaseParser

/**
 * Method to parse NSDictionary to PaymentMethod object
 * @param paymentDict NSDictionary to parse
 * @return PaymentMethod object
 */
- (PaymentMethod*)parsePaymentMethod:(NSDictionary*)paymentDict;

/**
 * Method to parse result to NSMutableArray containing Address objects
 * @param resultObject result to parse
 * @return NSMutableArray containing Address objects
 */
- (NSMutableArray*)parseAddresses:(id)resultObject;

/**
 * Method to parse NSDictionary to NSMutableArray containing PaymentCardRootGroup objects
 * @param paymentDict NSDictionary to parse
 * @return NSMutableArray containing PaymentCardRootGroup objects
 */
- (NSMutableArray*)parsePaymentMethodsTypes:(NSDictionary*)paymentDict;

/**
 * Method to parse result to NSMutableArray containing PaymentMethod objects
 * @param resultObject result to parse
 * @return NSMutableArray containing PaymentMethod objects
 */
- (NSMutableArray*)parsePaymentMethods:(id)resultObject;

@end
