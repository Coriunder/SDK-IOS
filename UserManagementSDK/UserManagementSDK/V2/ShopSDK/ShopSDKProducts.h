//
//  ShopSDKProducts.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods to perform requests to the Shop service related to products

#import "Coriunder.h"
#import "Product.h"

@interface ShopSDKProducts : Coriunder

/**
 * Get instance for ShopSDKProducts class.
 * In case there is no current instance, a new one will be created
 * @return ShopSDKProducts instance
 */
+ (ShopSDKProducts*)getInstance;



/**
 * Get list of products of exact category.
 *
 * @param category id of the category to load products from
 * @param shopId id of the shop to load products from
 * @param language set language to load products with
 * @param callback will be called after request completion
 */
- (void)getProductsOfCategory:(long)category shopId:(long)shopId language:(NSString*)language callback:(void (^)(BOOL success, NSMutableArray<Product*> *products, NSString* message))callback;

/**
 * Get exact product.
 *
 * @param productId id of the required product
 * @param merchantNumber id of the merchant which product belongs to
 * @param language language which product data should be returned with
 * @param callback will be called after request completion
 */
- (void)getProductWithId:(long)productId merchantNumber:(NSString*)merchantNumber language:(NSString*)language callback:(void (^)(BOOL success, Product *product, NSString* message))callback;

/**
 * Get list of products with exact parameters.
 *
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
 * @param callback will be called after request completion
 */
- (void)getProductsOnPage:(int)page pageSize:(int)pageSize categories:(NSArray<NSNumber*>*)categories countries:(NSArray<NSString*>*)countries includeGlobalRegion:(BOOL)includeGlobalRegion language:(NSString*)language merchantGroups:(NSArray<NSNumber*>*)merchantGroups merchantId:(NSString*)merchantId name:(NSString*)name promoOnly:(BOOL)promoOnly regions:(NSArray<NSString*>*)regions shopId:(long)shopId tags:(NSString*)tags callback:(void (^)(BOOL success, NSMutableArray<Product*> *products, NSString* message))callback;

@end
