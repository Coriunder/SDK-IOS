//
//  AppIdentityRequestBuilder.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods designed to prepare
//  NSDictionary to send with requests to AppIdentity service

#import <Foundation/Foundation.h>

@interface AppIdentityRequestBuilder : NSObject

/**
 * Prepare NSDictionary for GetContent request
 * @param contentName name of the content you need to get
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForGetContent:(NSString*)contentName;

/**
 * Prepare NSDictionary for Log request
 * @param severityId severity ID
 * @param message main log message
 * @param longMessage long log message
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForLog:(int)severityId message:(NSString*)message longMessage:(NSString*)longMessage;

/**
 * Prepare NSDictionary for SendContactEmail request
 * @param from email sender
 * @param subject email subject
 * @param body main email text
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForEmail:(NSString*)from subject:(NSString*)subject body:(NSString*)body;

@end