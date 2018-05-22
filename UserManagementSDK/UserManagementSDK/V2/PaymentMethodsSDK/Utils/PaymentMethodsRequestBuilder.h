//
//  PaymentMethodsRequestBuilder.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods designed to prepare
//  NSDictionary to send with requests to PaymentMethods service

#import <Foundation/Foundation.h>
#import "PaymentMethod.h"

@interface PaymentMethodsRequestBuilder : NSObject

/**
 * Prepare NSDictionary for DeleteStoredPaymentMethod request
 * @param cardId id of the payment method which has to be deleted
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForDeletePm:(long)cardId;

/**
 * Prepare NSDictionary for GetStoredPaymentMethod request
 * @param cardId id of the required payment method
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForGetPm:(long)cardId;

/**
 * Prepare NSDictionary for LinkPaymentMethod request
 * @param accountValue account value
 * @param bDate owner's date of birth
 * @param personalNumber owner's personal number
 * @param phoneNumber owner's phone number
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForLinkPm:(NSString*)accountValue birthDate:(NSDate*)bDate
                     personalNumber:(NSString*)personalNumber phoneNumber:(NSString*)phoneNumber ;

/**
 * Prepare NSDictionary for LoadPaymentMethod request
 * @param amount required amount
 * @param currencyIso ISO of the currency which should be loaded
 * @param paymentMethodId id of the payment method
 * @param pinCode current user's pin code
 * @param referenceCode reference code
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForLoadPm:(double)amount currencyIso:(NSString*)currencyIso paymentMethodId:(long)paymentMethodId
                            pinCode:(NSString*)pinCode referenceCode:(NSString*)referenceCode;

/**
 * Prepare NSDictionary for RequestPhysicalPaymentMethod request
 * @param providerID physical payment method's provider ID
 * @param addressLine1 physical payment method's main address
 * @param addressLine2 physical payment method's secondary address
 * @param city physical payment method's city
 * @param countryIso physical payment method's country ISO
 * @param postalCode physical payment method's postal code
 * @param stateIso physical payment method's state ISO
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForRequestPhysicalPm:(NSString*)providerID addressLine1:(NSString*)addressLine1
                                  addressLine2:(NSString*)addressLine2 city:(NSString*)city countryIso:(NSString*)countryIso
                                    postalCode:(NSString*)postalCode stateIso:(NSString*)stateIso;

/**
 * Prepare NSDictionary for StorePaymentMethod request
 * @param methodData NSDictionary containing payment method data
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForSavePm:(NSDictionary*)methodData;

/**
 * Prepare NSDictionary for StorePaymentMethods request
 * @param paymentMethods NSArray containing PaymentMethod objects for payment methods which
 *                       have to be updated.
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForSavePms:(NSArray<PaymentMethod*>*)paymentMethods;

/**
 * Create NSDictionary from PaymentMethod object
 * @param paymentMethod PaymentMethod object to be parsed to NSDictionary
 * @param isNew detects whether it is a new payment method
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildCardJson:(PaymentMethod*)paymentMethod isNew:(BOOL)isNew;

@end