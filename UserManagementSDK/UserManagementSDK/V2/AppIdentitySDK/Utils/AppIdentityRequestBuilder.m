//
//  AppIdentityRequestBuilder.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods designed to prepare
//  NSDictionary to send with requests to AppIdentity service

#import "AppIdentityRequestBuilder.h"

@implementation AppIdentityRequestBuilder

- (NSDictionary*)buildJsonForGetContent:(NSString*)contentName {
    return @{ @"contentName":[self getNonNilValueForString:contentName], };
}

- (NSDictionary*)buildJsonForLog:(int)severityId message:(NSString*)message longMessage:(NSString*)longMessage {
    return @{ @"severityId":@(severityId),
              @"message":[self getNonNilValueForString:message],
              @"longMessage":[self getNonNilValueForString:longMessage], };
}

- (NSDictionary*)buildJsonForEmail:(NSString*)from subject:(NSString*)subject body:(NSString*)body {
    return @{ @"from":[self getNonNilValueForString:from],
              @"subject":[self getNonNilValueForString:subject],
              @"body":[self getNonNilValueForString:body], };
}

/**
 * Method to get non-nil NSString object
 * @param string NSString which shouldn't be nil
 */
-(NSString*)getNonNilValueForString:(NSString*)string {
    return (string == nil) ? @"" : string;
}

@end