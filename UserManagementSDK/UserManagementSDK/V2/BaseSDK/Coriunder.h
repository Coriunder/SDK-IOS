//
//  Coriunder.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Base class for setting up connection

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#define DEFAULTS_EMAIL @"coriunderEmail"
#define DEFAULTS_USERNAME @"coriunderUserName"
#define DEFAULTS_URL @"coriunderUrl"
#define DEFAULTS_APPTOKEN @"coriunderAppToken"

@interface Coriunder : NSObject

@property (strong, nonatomic) NSString *serviceUrlPart;



/**
 * Send POST request
 * @param params request body
 * @param method service method name
 * @param completion callback to be called on request completion
 */
- (void)sendPostRequestWithParameters:(NSDictionary *)params withMethod:(NSString *)method callback:(void (^)(BOOL success, id resultObject))completion;

/**
 * Send GET request
 * @param params request body
 * @param method service method name
 * @param completion callback to be called on request completion
 */
- (void)sendGetRequestWithParameters:(NSDictionary *)params withMethod:(NSString *)method callback:(void (^)(BOOL success, id resultObject))completion;

/**
 * Set custom application token
 * @param appToken application token
 */
- (void)setAppToken:(NSString*)appToken;

/**
 * Get current application token
 * @return application token
 */
- (NSString*)getAppToken;

/**
 * Set custom url (should start with "http://")
 * @param url custom url
 */
- (void)setServiceUrl:(NSString*)url;

/**
 * Get URL for the service
 * @return service URL
 */
- (NSString*)getServiceUrl;

/**
 * Detect whether user is logged in
 * @return user login state
 */
- (BOOL)isUserLoggedIn;

@end
