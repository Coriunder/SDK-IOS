//
//  CustomerSDKShippingAddresses.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods to perform requests to the Customer service related to shipping addresses

#import "Coriunder.h"
#import "ServiceMultiResult.h"
#import "ShippingAddress.h"

@interface CustomerSDKShippingAddresses : Coriunder

/**
 * Get instance for CustomerSDKShippingAddresses class.
 * In case there is no current instance, a new one will be created
 * @return CustomerSDKShippingAddresses instance
 */
+ (CustomerSDKShippingAddresses*)getInstance;



/**
 * Delete exact shipping address
 *
 * @param addressId id of address which has to be deleted
 * @param callback will be called after request completion
 */
- (void)deleteShippingAddressWithId:(long)addressId callback:(void (^)(BOOL success, NSString* message))callback;

/**
 * Get exact shipping address by id
 *
 * @param addressId id of the required shipping address
 * @param callback will be called after request completion
 */
- (void)getShippingAddressWithId:(long)addressId callback:(void (^)(BOOL success, ShippingAddress *address, NSString* message))callback;

/**
 * Get all shipping addresses added by current user
 *
 * @param callback will be called after request completion
 */
- (void)getShippingAddressesWithCallback:(void (^)(BOOL success, NSMutableArray<ShippingAddress*>* addressesArray, NSString* message))callback;

/**
 * Add new shipping address for current user
 *
 * @param shippingAddress new shipping address data
 * @param callback will be called after request completion
 */
- (void)addNewShippingAddress:(ShippingAddress*)shippingAddress callback:(void (^)(BOOL success, ServiceMultiResult *result, NSString* message))callback;

/**
 * Update existing shipping address for current user
 *
 * @param shippingAddress updated shipping address data
 * @param callback will be called after request completion
 */
- (void)updateShippingAddress:(ShippingAddress*)shippingAddress callback:(void (^)(BOOL success, ServiceMultiResult *result, NSString* message))callback;

/**
 * Add or update several shipping address for current user at once
 *
 * @param shippingAddresses NSArray containing ShippingAddress objects for shipping addresses
 *                          which have to be updated.
 * @param callback will be called after request completion
 */
- (void)saveShippingAddresses:(NSArray<ShippingAddress*>*)shippingAddresses callback:(void (^)(BOOL success, ServiceMultiResult *result, NSString* message))callback;

@end
