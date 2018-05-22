//
//  InternationalRequestBuilder.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods designed to prepare
//  NSDictionary to send with requests to International service

#import <Foundation/Foundation.h>

@interface InternationalRequestBuilder : NSObject

/**
 * Prepare NSDictionary for GetErrorCodes request
 * @param language language which you want to receive errors with
 * @param groups groups of errors you need to get info about
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForErrorCodes:(NSString*)language groups:(NSArray<NSString*>*)groups;

@end