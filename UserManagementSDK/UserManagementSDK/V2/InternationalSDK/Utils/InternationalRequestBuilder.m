//
//  InternationalRequestBuilder.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods designed to prepare
//  NSDictionary to send with requests to International service

#import "InternationalRequestBuilder.h"

@implementation InternationalRequestBuilder

- (NSDictionary*)buildJsonForErrorCodes:(NSString*)language groups:(NSArray<NSString*>*)groups {
    return @{ @"language": [self getNonNilValueForString:language],
              @"groups": (groups != nil && groups.count > 0) ? groups : [NSNull null], };
}

/**
 * Method to get non-nil NSString object
 * @param string NSString which shouldn't be nil
 */
-(NSString*)getNonNilValueForString:(NSString*)string {
    return (string == nil) ? @"" : string;
}

@end
