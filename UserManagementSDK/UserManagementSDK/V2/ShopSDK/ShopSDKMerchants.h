//
//  ShopSDKMerchants.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods to perform requests to the Shop service related to merchants

#import "Coriunder.h"
#import "Merchant.h"
#import "ProductCategory.h"

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

@interface ShopSDKMerchants : Coriunder

/**
 * Get instance for ShopSDKMerchants class.
 * In case there is no current instance, a new one will be created
 * @return ShopSDKMerchants instance
 */
+ (ShopSDKMerchants*)getInstance;



/**
 * Get exact merchant.
 *
 * @param merchantNumber id of the required merchant
 * @param callback will be called after request completion
 */
- (void)getMerchant:(NSString*)merchantNumber callback:(void (^)(BOOL success, Merchant* merchant, NSString* message))callback;

/**
 * Get categories for exact merchant.
 *
 * @param merchantNumber id of the required merchant
 * @param language set which language should be included
 * @param callback will be called after request completion
 */
- (void)getCategoriesForMerchant:(NSString*)merchantNumber language:(NSString*)language callback:(void (^)(BOOL success, NSArray<ProductCategory*>* categories, NSString* message))callback;

/**
 * Get merchant policies content.
 *
 * @param merchantNumber id of the required merchant
 * @param language language of content to return
 * @param contentName name of content you want to get. Applicable values are About.html,
 *                    Policy.html and Terms.html
 * @param callback will be called after request completion
 */
- (void)getContentForMerchant:(NSString*)merchantNumber language:(NSString*)language contentName:(NSString*)contentName callback:(void (^)(BOOL success, NSString* message))callback;

/**
 * Get list of merchants with exact parameters.
 *
 * @param groupId id of the group which merchants should belong to
 * @param status merchant status
 * @param text search text
 * @param callback will be called after request completion
 */
- (void)getMerchantsWithGroup:(long)groupId status:(merchantStatus)status text:(NSString*)text callback:(void (^)(BOOL success, NSMutableArray<Merchant*> *merchants, NSString* message))callback;

@end
