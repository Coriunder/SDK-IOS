//
//  ShopSDKDownloads.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods to perform requests to the Shop service related to downloads

#import "Coriunder.h"
#import "CartItem.h"

@interface ShopSDKDownloads : Coriunder

/**
 * Get instance for ShopSDKDownloads class.
 * In case there is no current instance, a new one will be created
 * @return ShopSDKDownloads instance
 */
+ (ShopSDKDownloads*)getInstance;



/**
 * Download an item by id (requires authorization)
 *
 * @param itemId id of the item to download
 * @param asPlainData form of downloaded data
 * @param callback will be called after request completion
 */
- (void)downloadItemWithId:(long)itemId asPlainData:(BOOL)asPlainData callback:(void (^)(BOOL success, NSString* message))callback;

/**
 * Download an item by file key (doesn't require authorization)
 *
 * @param fileKey file key of the item to download
 * @param asPlainData form of downloaded data
 * @param callback will be called after request completion
 */
- (void)downloadItemWithKey:(NSString*)fileKey asPlainData:(BOOL)asPlainData callback:(void (^)(BOOL success, NSString* message))callback;

/**
 * Get list of downloads.
 *
 * @param page number of the page with results, minimum value is 1
 * @param pageSize results amount per page
 * @param callback will be called after request completion
 */
- (void)getDownloadsOnPage:(int)page pageSize:(int)pageSize callback:(void (^)(BOOL success, NSMutableArray<CartItem*> *downloads, NSString* message))callback;

@end
