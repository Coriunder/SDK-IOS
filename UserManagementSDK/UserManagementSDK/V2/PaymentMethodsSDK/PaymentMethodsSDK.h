//
//  PaymentMethodsSDK.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods to perform requests to the PaymentMethods service

#import "Coriunder.h"
#import "ServiceMultiResult.h"
#import "PaymentCardRootGroup.h"
#import "PaymentMethod.h"

@interface PaymentMethodsSDK : Coriunder

/**
 * Get instance for PaymentMethodsSDK class.
 * In case there is no current instance, a new one will be created
 * @return PaymentMethodsSDK instance
 */
+ (PaymentMethodsSDK*)getInstance;



/**
 * Delete exact payment method
 *
 * @param cardId id of the payment method which has to be deleted
 * @param callback will be called after request completion
 */
- (void)deletePaymentMethodWithId:(long)cardId callback:(void (^)(BOOL success, NSString* message))callback;

/**
 * Get all billing addresses added by current user
 *
 * @param callback will be called after request completion
 */
- (void)getBillingAddressesWithCallback:(void (^)(BOOL success, NSMutableArray<Address*> *array, NSString* message))callback;

/**
 * Get available payment methods' types
 *
 * @param callback will be called after request completion
 */
- (void)getPaymentMethodsTypes:(void (^)(BOOL success, NSMutableArray<PaymentCardRootGroup*> *paymentGroups, NSString* message))callback;

/**
 * Get exact payment method by id
 *
 * @param cardId id of the required payment method
 * @param callback will be called after request completion
 */
- (void)getPaymentMethodWithId:(long)cardId callback:(void (^)(BOOL success, PaymentMethod *paymentMethod, NSString* message))callback;

/**
 * Get all payment methods added by current user
 *
 * @param callback will be called after request completion
 */
- (void)getPaymentMethodsWithCallback:(void (^)(BOOL success, NSMutableArray<PaymentMethod*>* paymentMethodsArray, NSString* message))callback;

/**
 * Link payment method
 *
 * @param accountValue account value
 * @param bDate owner's date of birth
 * @param personalNumber owner's personal number
 * @param phoneNumber owner's phone number
 * @param callback will be called after request completion
 */
- (void)linkPaymentMethodWithAccountValue:(NSString*)accountValue birthDate:(NSDate*)bDate personalNumber:(NSString*)personalNumber phoneNumber:(NSString*)phoneNumber callback:(void (^)(BOOL success, ServiceResult *result, NSString* message))callback;

/**
 * Load payment method
 *
 * @param amount required amount
 * @param currencyIso ISO of the currency which should be loaded
 * @param paymentMethodID id of the payment method
 * @param pinCode current user's pin code
 * @param referenceCode reference code
 * @param callback will be called after request completion
 */
- (void)loadPaymentMethodWithAmount:(double)amount currencyIso:(NSString*)currencyIso paymentMethodId:(long)paymentMethodId pinCode:(NSString*)pinCode referenceCode:(NSString*)referenceCode callback:(void (^)(BOOL success, ServiceResult *result, NSString* message))callback;

/**
 * Request physical payment method
 *
 * @param providerID physical payment method's provider ID
 * @param addressLine1 physical payment method's main address
 * @param addressLine2 physical payment method's secondary address
 * @param city physical payment method's city
 * @param countryIso physical payment method's country ISO
 * @param postalCode physical payment method's postal code
 * @param stateIso physical payment method's state ISO
 * @param callback will be called after request completion
 */
- (void)requestPhysicalPaymentMethodWithProviderId:(NSString*)providerID addressLine1:(NSString*)addressLine1 addressLine2:(NSString*)addressLine2 city:(NSString*)city countryIso:(NSString*)countryIso postalCode:(NSString*)postalCode stateIso:(NSString*)stateIso callback:(void (^)(BOOL success, ServiceResult *result, NSString* message))callback;

/**
 * Add new payment method for current user
 *
 * @param paymentMethod new payment method data
 * @param callback will be called after request completion
 */
- (void)addNewPaymentMethod:(PaymentMethod*)paymentMethod callback:(void (^)(BOOL success, ServiceResult *result, NSString* message))callback;

/**
 * Update existing payment method for current user
 *
 * @param paymentMethod updated payment method data
 * @param callback will be called after request completion
 */
- (void)updatePaymentMethod:(PaymentMethod*)paymentMethod callback:(void (^)(BOOL success, ServiceResult *result, NSString* message))callback;

/**
 * Add or update several payment methods for current user at once
 *
 * @param paymentMethods NSArray containing PaymentMethod objects for payment methods which
 *                       have to be updated.
 * @param callback will be called after request completion
 */
- (void)savePaymentMethods:(NSArray<PaymentMethod*>*)paymentMethods callback:(void (^)(BOOL success, ServiceMultiResult *result, NSString* message))callback;

@end
