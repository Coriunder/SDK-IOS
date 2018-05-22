//
//  ShopRequestBuilder.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods designed to prepare
//  NSDictionary to send with requests to Shop service

#import <Foundation/Foundation.h>
#import "ShopSDKMerchants.h"
#import "Cart.h"

@interface ShopRequestBuilder : NSObject

/**
 * Prepare NSDictionary for GetCart request
 * @param cookie cookie of the required cart
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForGetCart:(NSString*)cookie;

/**
 * Prepare NSDictionary for GetCartOfTransaction request
 * @param transactionId transaction id of the required cart
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForGetCartOfTransaction:(long)transactionId;

/**
 * Prepare NSDictionary for SetCart request
 * @param cart cart object for the cart you want to update
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForUpdateCart:(Cart*)cart;

/**
 * Prepare NSDictionary for Download request
 * @param itemId id of the item to download
 * @param asPlainData form of downloaded data
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForDownload:(long)itemId asPlainData:(BOOL)asPlainData;

/**
 * Prepare NSDictionary for DownloadUnauthorized request
 * @param fileKey file key of the item to download
 * @param asPlainData form of downloaded data
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForDownloadUnauthorized:(NSString*)fileKey asPlainData:(BOOL)asPlainData;

/**
 * Prepare NSDictionary for GetDownloads request
 * @param page number of the page with results, minimum value is 1
 * @param pageSize results amount per page
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForDownloads:(int)page pageSize:(int)pageSize;

/**
 * Prepare NSDictionary for GetMerchant request
 * @param merchantNumber id of the required merchant
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForGetMerchant:(NSString*)merchantNumber;

/**
 * Prepare NSDictionary for GetMerchantCategories request
 * @param merchantNumber id of the required merchant
 * @param language set which language should be included
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForGetCategories:(NSString*)merchantNumber language:(NSString*)language;

/**
 * Prepare NSDictionary for GetMerchantContent request
 * @param merchantNumber id of the required merchant
 * @param language language of content to return
 * @param contentName name of content you want to get
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForGetContent:(NSString*)merchantNumber language:(NSString*)language contentName:(NSString*)contentName;

/**
 * Prepare NSDictionary for GetMerchants request
 * @param groupId id of the group which merchants should belong to
 * @param status merchant status
 * @param text search text
 * @param appToken current application token
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForGetMerchants:(long)groupId status:(merchantStatus)status text:(NSString*)text appToken:(NSString*)appToken;

/**
 * Prepare NSDictionary for GetCategorisedProducts request
 * @param category id of the category to load products from
 * @param shopId id of the shop to load products from
 * @param language set language to load products with
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForGetCategorisedProducts:(long)category shopId:(long)shopId language:(NSString*)language;

/**
 * Prepare NSDictionary for GetProduct request
 * @param productId id of the required product
 * @param merchantNumber id of the merchant which product belongs to
 * @param language language which product data should be returned with
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForGetProduct:(long)productId merchantNumber:(NSString*)merchantNumber language:(NSString*)language;

/**
 * Prepare NSDictionary for GetProducts request
 * @param page number of the page with results, minimum value is 1
 * @param pageSize results amount per page
 * @param categories array of product categories to search in
 * @param countries array of countries to search in
 * @param includeGlobalRegion set whether you need global region products to be included or not
 * @param language set language to get products with
 * @param merchantGroups array of merchant groups to search in
 * @param merchantId specify merchant id to get exact merchant's products
 * @param name name of the product
 * @param promoOnly get only promo products
 * @param regions array of regions to search in
 * @param shopId id of the shop to search products in
 * @param tags tags to search product with
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForGetProducts:(int)page pageSize:(int)pageSize categories:(NSArray<NSNumber*>*)categories
                               countries:(NSArray<NSString*>*)countries includeGlobalRegion:(BOOL)includeGlobalRegion
                                language:(NSString*)language merchantGroups:(NSArray<NSNumber*>*)merchantGroups
                              merchantId:(NSString*)merchantId name:(NSString*)name promoOnly:(BOOL)promoOnly
                                 regions:(NSArray<NSString*>*)regions shopId:(long)shopId tags:(NSString*)tags;

/**
 * Prepare NSDictionary for GetShop request
 * @param shopId id of the required shop
 * @param merchantNumber id of the merchant which shop has to be received
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForGetShop:(long)shopId merchantNumber:(NSString*)merchantNumber;

/**
 * Prepare NSDictionary for GetShopIds request
 * @param subDomainName sub-domain which the shop belongs too
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForGetShopIds:(NSString*)subDomainName;

/**
 * Prepare NSDictionary for GetShops request
 * @param merchantNumber id of the merchant which shops have to be received
 * @param culture culture of required shops
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForGetShops:(NSString*)merchantNumber culture:(NSString*)culture;

/**
 * Prepare NSDictionary for GetShopsByLocation request
 * @param regions array of regions to search in
 * @param countries array of countries to search in
 * @param includeGlobalShops set whether you need global region shops to be included or not
 * @param culture culture of required shops
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForGetShopsByLocation:(NSArray<NSString*>*)regions countries:(NSArray<NSString*>*)countries
                             includeGlobalShops:(BOOL)includeGlobalShops culture:(NSString*)culture;

/**
 * Prepare NSDictionary for SetSession request
 * @param declineUrl set decline URL
 * @param imageHeight desired image height
 * @param imageWidth desired image width
 * @param pendingUrl set pending URL
 * @param successUrl set success URL
 * @param appToken current application token
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForSetSession:(NSString*)declineUrl imageHeight:(long)imageHeight imageWidth:(long)imageWidth
                             pendingUrl:(NSString*)pendingUrl successUrl:(NSString*)successUrl appToken:(NSString*)appToken;

@end
