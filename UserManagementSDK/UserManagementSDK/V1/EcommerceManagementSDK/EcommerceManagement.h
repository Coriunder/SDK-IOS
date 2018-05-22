//
//  EcommerceManagement.h
//  UserManagementSDK
//
//  Created by Lev T on 03/02/16.
//  Copyright © 2016 Sapdan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkManagerOld.h"
#import "ProductOld.h"
#import "CartOld.h"

typedef NS_ENUM(NSUInteger, merchantStatus) {
    statusArchived,
    statusNew,
    statusBlocked,
    statusClosed,
    statusLoginOnly,
    statusIntegration,
    statusProcessing,
    statusAll
};

@interface EcommerceManagement : NetworkManagerOld

+ (EcommerceManagement *)getInstance;

/**
 * Get product by id.
 *
 * @param
 * - productId - id of required product
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - Product *product - Product object (nil in case request was NOT successful)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)getProductWithId:(long)productId callback:(void (^)(bool success, ProductOld *product, NSString* message))callback;

/**
 * Get list of products. Returns results by pages.
 *
 * @param
 * - page - number of the page with results, minimum value is 1
 * - pageSize - results amount per page
 * - categories - array of product categories to search in. Set to nil to get products from all categories
 * - merchantGroups - array of merchant groups to search in. Set to nil to get products from all merchant groups
 * - merchantId - specify merchant id to get exact merchant products or set to nil to search through all merchants
 * - text - text to search or nil
 * - promoOnly - get only promo products
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSMutableArray* products - array containing Product objects (nil in case request was NOT successful)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)getProductsOnPage:(int)page pageSize:(int)pageSize categories:(NSArray*)categories merchantGroups:(NSArray*)merchantGroups merchantId:(NSString*)merchantId text:(NSString*)text promoOnly:(BOOL)promoOnly callback:(void (^)(bool success, NSMutableArray *products, NSString* message))callback;

/**
 * Get next product for merchant.
 *
 * @param
 * - merchantNumber - current merchant id
 * - productId - current product id
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSInteger productId - next product id. Returns 0 in case there is no next product or not existing
 *   product id in case of any other issue
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)getNextProductForMerchantWithNumber:(NSString*)merchantNumber productId:(long)productId callback:(void (^)(bool success, NSInteger productId, NSString* message))callback;

/**
 * Get previous product for merchant.
 *
 * @param
 * - merchantNumber - current merchant id
 * - productId - current product id
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSInteger productId - previous product id. Returns 0 in case there is no previous product or not existing
 *   product id in case of any other issue 
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)getPrevProductForMerchantWithNumber:(NSString*)merchantNumber productId:(long)productId callback:(void (^)(bool success, NSInteger productId, NSString* message))callback;





/**
 * Get merchant by id.
 *
 * @param
 * - merchantNumber - id of required merchant, can't be nil
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - Merchant* merchant - Merchant object (nil in case request was NOT successful)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)getMerchantWithId:(NSString*)merchantNumber callback:(void (^)(bool success, MerchantOld* merchant, NSString* message))callback;

/**
 * Send email to the merchant.
 *
 * @param
 * - merchantNumber - id of the merchant you want to send email to, can't be empty or nil
 * - from - sender email, can't be empty or nil
 * - subject - email subject, can't be empty or nil
 * - body - email text, can't be empty or nil
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)sendEmailToMerchantWithId:(NSString*)merchantNumber from:(NSString*)from withSubject:(NSString*)subject andBody:(NSString*)body callback:(void (^)(bool success, NSString* message))callback;

/**
 * Get categories for exact merchant.
 *
 * @param
 * - merchantNumber - id of required merchant, can't be nil
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSArray* categories - array containing ProductCategory objects (nil in case request was NOT successful)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)getCategoriesForMerchantWithId:(NSString*)merchantNumber callback:(void (^)(bool success, NSArray* categories, NSString* message))callback;

/**
 * Get merchant policies content.
 *
 * @param
 * - merchantNumber - id of required merchant, can't be empty or nil
 * - contentName - name of content you want to get, applicable values are About.html, Policy.html and Terms.html, 
 *   can't be empty or nil
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)getContentForMerchantWithId:(NSString*)merchantNumber contentName:(NSString*)contentName callback:(void (^)(bool success, NSString* message))callback;

/**
 * Get merchants with exact parameters.
 *
 * @param
 * - groupId - id of the group which the merchant should belong to, send 0 to search through all groups
 * - text - search text, send nil to ignore this parameter
 * - status - merchant status, send statusAll to search merchants with any status.
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSMutableArray* merchants - array containing Merchant objects (nil in case request was NOT successful)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)getMerchantsWithGroupID:(long)groupId text:(NSString*)text status:(merchantStatus)status callback:(void (^)(bool success, NSMutableArray* merchants, NSString* message))callback;





/**
 * Get list of downloads. Returns results by pages.
 *
 * @param
 * - page - number of the page with results, minimum value is 1
 * - pageSize - results amount per page
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSMutableArray* downloads - array containing CartItem objects (nil in case request was NOT successful)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)getDownloadsOnPage:(int)page pageSize:(int)pageSize callback:(void (^)(bool success, NSMutableArray *downloads, NSString* message))callback;

/**
 * Download an item by id (requires authorization)
 *
 * @param
 * - itemId - id of the item to download
 * - asPlainData - form of downloaded data
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)downloadItemWithId:(int)itemId asPlainData:(BOOL)asPlainData callback:(void (^)(bool success, NSString* message))callback;





/**
 * Create a new cart
 *
 * @param
 * - merchantId - id of the mecrhant for which the cart should be created
 * - currencyIso - cart currency ISO
 */
- (CartOld*)createNewCartForMerchant:(NSString*)merchantId currencyIso:(NSString*)currencyIso;

/**
 * Get active carts.
 *
 * @param
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSMutableArray *carts - array containing Cart objects (nil in case request was NOT successful)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)getActiveCarts:(void (^)(bool success, NSMutableArray *carts, NSString* message))callback;

/**
 * Update cart data.
 *
 * @param
 * - cart - Cart object of the cart you want to update, can be received using getActiveCarts method, can't be nil
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)updateCart:(CartOld*)cart callback:(void (^)(bool success, NSString* message))callback;

/**
 * Get cart by cookie.
 *
 * @param
 * - cartCookie - cookie of the required cart, can't be empty or nil
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - Cart* cart - Cart object (nil in case request was NOT successful)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)getCartWithCookie:(NSString*)cartCookie callback:(void (^)(bool success, CartOld* cart, NSString* message))callback;

/**
 * Get cart by transaction id.
 *
 * @param
 * - transactionId - transaction id of the required cart
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - Cart* cart - Cart object (nil in case request was NOT successful)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)getCartWithTransaction:(long)transactionId callback:(void (^)(bool success, CartOld* cart, NSString* message))callback;





/**
 * Allows to set custom product image size in case it is called before getting product
 *
 * @param
 * - imageWidth - desired image width
 * - imageHeight - desired image height
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)setSessionWithImageWidth:(long)imageWidth imageHeight:(long)imageHeight callback:(void (^)(bool success, NSString* message))callback;

@end