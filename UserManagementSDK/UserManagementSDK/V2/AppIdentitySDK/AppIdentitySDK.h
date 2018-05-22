//
//  AppIdentitySDK.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods to perform requests to the AppIdentity service

#import "Coriunder.h"
#import "Identity.h"
#import "MerchantGroup.h"

@interface AppIdentitySDK : Coriunder

/**
 * Get instance for AppIdentitySDK class.
 * In case there is no current instance, a new one will be created
 * @return AppIdentitySDK instance
 */
+ (AppIdentitySDK*)getInstance;



/**
 * Get content for the application
 *
 * @param contentName name of the content you need to get
 * @param callback will be called after request completion
 */
- (void)getContentWithName:(NSString*)contentName callback:(void (^)(BOOL success, NSString* message))callback;

/**
 * Get identity data about the current app
 *
 * @param callback will be called after request completion
 */
- (void)getIdentityDetailsWithCallback:(void (^)(BOOL success, Identity *identity, NSString* message))callback;

/**
 * Get the list of merchant groups supported by the application
 *
 * @param callback will be called after request completion
 */
- (void)getMerchantGroupsWithCallback:(void (^)(BOOL success, NSMutableArray<MerchantGroup*> *result, NSString* message))callback;

/**
 * Get the list of currencies supported by the application
 *
 * @param callback will be called after request completion
 */
- (void)getSupportedCurrenciesWithCallback:(void (^)(BOOL success, NSArray<NSString*> *result, NSString* message))callback;

/**
 * Get the list of payment methods supported by the application
 *
 * @param callback will be called after request completion
 */
- (void)getSupportedPaymentMethodsWithCallback:(void (^)(BOOL success, NSArray<NSNumber*> *result, NSString* message))callback ;

/**
 * Log data to the server
 *
 * @param severityId severity ID
 * @param message main log message
 * @param longMessage long log message
 * @param callback will be called after request completion
 */
- (void)logWithSeverityId:(int)severityId message:(NSString*)message longMessage:(NSString*)longMessage callback:(void (^)(BOOL success, NSString* message))callback;

/**
 * Send email to the application owner
 *
 * @param from email sender
 * @param subject email subject
 * @param body main email text
 * @param callback will be called after request completion
 */
- (void)sendEmailFrom:(NSString*)from subject:(NSString*)subject body:(NSString*)body callback:(void (^)(BOOL success, NSString* message))callback;

@end
