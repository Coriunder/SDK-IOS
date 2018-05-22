//
//  ShopSDKCarts.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods to perform requests to the Shop service related to carts

#import "Coriunder.h"
#import "Cart.h"

@interface ShopSDKCarts : Coriunder

/**
 * Get instance for ShopSDKCarts class.
 * In case there is no current instance, a new one will be created
 * @return ShopSDKCarts instance
 */
+ (ShopSDKCarts*)getInstance;



/**
 * Create a new cart locally to have ability to put products in it
 *
 * @param merchantId id of the merchant which the cart should be created for
 * @param currencyIso currency which the cart should be created for
 */
- (Cart*)createNewCartForMerchant:(NSString*)merchantId currencyIso:(NSString*)currencyIso;

/**
 * Get active carts.
 *
 * @param callback will be called after request completion
 */
- (void)getActiveCarts:(void (^)(BOOL success, NSMutableArray<Cart*> *carts, NSString* message))callback;

/**
 * Get exact cart by its cookie.
 *
 * @param cookie cookie of the required cart
 * @param callback will be called after request completion
 */
- (void)getCartWithCookie:(NSString*)cookie callback:(void (^)(BOOL success, Cart* cart, NSString* message))callback;

/**
 * Get cart for exact transaction id.
 *
 * @param transactionId transaction id of the required cart
 * @param callback will be called after request completion
 */
- (void)getCartOfTransaction:(long)transactionId callback:(void (^)(BOOL success, Cart* cart, NSString* message))callback;

/**
 * Update cart data.
 *
 * @param cart cart object for the cart you want to update
 * @param callback will be called after request completion
 */
- (void)updateCart:(Cart*)cart callback:(void (^)(BOOL success, NSString* message))callback;

@end
