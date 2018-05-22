//
//  ShopSDKShops.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods to perform requests to the Shop service related to shops

#import "Coriunder.h"
#import "Shop.h"

@interface ShopSDKShops : Coriunder

/**
 * Get instance for ShopSDKShops class.
 * In case there is no current instance, a new one will be created
 * @return ShopSDKShops instance
 */
+ (ShopSDKShops*)getInstance;



/**
 * Get exact shop
 *
 * @param shopId id of the required shop
 * @param merchantNumber id of the merchant which shop has to be received
 * @param callback will be called after request completion
 */
- (void)getShop:(long)shopId merchantNumber:(NSString*)merchantNumber callback:(void (^)(BOOL success, Shop *shop, NSString* message))callback;

/**
 * Get shop for a sub-domain
 *
 * @param subDomainName sub-domain which the shop belongs too
 * @param callback will be called after request completion
 */
- (void)getShopIds:(NSString*)subDomainName callback:(void (^)(BOOL success, NSString *merchantNumber, long shopId, NSString* message))callback;

/**
 * Get list of shops matching specified params
 *
 * @param merchantNumber id of the merchant which shops have to be received
 * @param culture culture of required shops
 * @param callback will be called after request completion
 */
- (void)getShopsForMerchant:(NSString*)merchantNumber culture:(NSString*)culture callback:(void (^)(BOOL success, NSMutableArray<Shop*> *result, NSString* message))callback;

/**
 * Get list of shops at the specified location
 *
 * @param regions array of regions to search in
 * @param countries array of countries to search in
 * @param includeGlobalShops set whether you need global region shops to be included or not
 * @param culture culture of required shops
 * @param callback will be called after request completion
 */
- (void)getShopsAtRegions:(NSArray<NSString*>*)regions countries:(NSArray<NSString*>*)countries includeGlobalShops:(BOOL)includeGlobalShops culture:(NSString*)culture callback:(void (^)(BOOL success, NSMutableArray<Shop*> *result, NSString* message))callback;

/**
 * Set urls and image sizes for the session
 *
 * @param declineUrl set decline URL
 * @param imageHeight desired image height
 * @param imageWidth desired image width
 * @param pendingUrl set pending URL
 * @param successUrl set success URL
 * @param callback will be called after request completion
 */
- (void)setSessionWithDeclineUrl:(NSString*)declineUrl imageHeight:(long)imageHeight imageWidth:(long)imageWidth pendingUrl:(NSString*)pendingUrl successUrl:(NSString*)successUrl callback:(void (^)(BOOL success, NSString* message))callback;

@end
