//
//  BaseParser.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Commonly used parser methods

#import <Foundation/Foundation.h>
#import "ServiceResult.h"
#import "ServiceMultiResult.h"
#import "Address.h"
#import "Merchant.h"

@interface BaseParser : NSObject

/**
 * Get object from NSDictionary
 * @param name key for the required value
 * @param dict NSDictionary to get value from
 * @return required value or nil in case of error
 */
- (id)getObject:(NSString*)name from:(NSDictionary*)dict;

/**
 * Get NSDictionary value from NSDictionary
 * @param name key for the required value
 * @param dict NSDictionary to get value from
 * @return required value or [NSDictionary new] in case of error
 */
- (NSDictionary*)getDictionary:(NSString*)name from:(NSDictionary*)dict;

/**
 * Get NSArray value from NSDictionary
 * @param name key for the required value
 * @param dict NSDictionary to get value from
 * @return required value or [NSArray new] in case of error
 */
- (NSArray*)getArray:(NSString*)name from:(NSDictionary*)dict;

/**
 * Get NSString value from NSDictionary
 * @param name key for the required value
 * @param dict NSDictionary to get value from
 * @return required value or @"" in case of error
 */
- (NSString*)getString:(NSString*)name from:(NSDictionary*)dict;

/**
 * Get long value from NSDictionary
 * @param name key for the required value
 * @param dict NSDictionary to get value from
 * @return required value or 0 in case of error
 */
- (long)getLong:(NSString*)name from:(NSDictionary*)dict;

/**
 * Get int value from NSDictionary
 * @param name key for the required value
 * @param dict NSDictionary to get value from
 * @return required value or 0 in case of error
 */
- (int)getInt:(NSString*)name from:(NSDictionary*)dict;

/**
 * Get double value from NSDictionary
 * @param name key for the required value
 * @param dict NSDictionary to get value from
 * @return required value or 0 in case of error
 */
- (double)getDouble:(NSString*)name from:(NSDictionary*)dict;

/**
 * Get BOOL value from NSDictionary
 * @param name key for the required value
 * @param dict NSDictionary to get value from
 * @return required value or NO in case of error
 */
- (BOOL)getBool:(NSString*)name from:(NSDictionary*)dict;

/**
 * Get NSDate value from NSDictionary
 * @param name key for the required value
 * @param dict NSDictionary to get value from
 * @return required value or [NSDate new] in case of error
 */
- (NSDate*)getReadableDate:(NSString*)name from:(NSDictionary*)dict;



/**
 * Method to parse NSDictionary to ServiceResult object
 * @param dict NSDictionary to parse
 * @return ServiceResult object
 */
- (ServiceResult*)parseServiceResult:(NSDictionary*)dict;

/**
 * Method to parse NSDictionary to Address object
 * @param addressDict NSDictionary to parse
 * @return Address object
 */
- (Address*)parseAddress:(NSDictionary*)addressDict;

/**
 * Method to parse NSDictionary to Merchant object
 * @param merchantDict NSDictionary to parse
 * @return Merchant object
 */
- (Merchant*)parseMerchant:(NSDictionary*)merchantDict;



/**
 * @param callback callback to be called on request result
 * @return listener which parses result to a ServiceResult model and calls the callback
 */
- (void (^)(BOOL success, id resultObject))createServiceCallbackWithUserCallback:(void (^)(BOOL success, ServiceResult *result, NSString *message))callback;

/**
 * @param callback callback to be called on request result
 * @return listener which parses result to a ServiceMultiResult model and calls the callback
 */
- (void (^)(BOOL success, id resultObject))createServiceMultiCallbackWithUserCallback:(void (^)(BOOL success, ServiceMultiResult *result, NSString *message))callback;

/**
 * @param callback callback to be called on request result
 * @return listener which parses result and calls the callback
 */
- (void (^)(BOOL success, id resultObject))createBasicCallbackWithUserCallback:(void (^)(BOOL success, NSString *message))callback getSuccess:(BOOL)getSuccess;

/**
 * Method to get real message from error
 * @param error error to parse
 * @return error message
 */
- (NSString*)parseError:(NSError*)error;

@end