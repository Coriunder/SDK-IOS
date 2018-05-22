//
//  AccountRequestBuilder.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods designed to prepare
//  NSDictionary to send with requests to Account service

#import "AccountRequestBuilder.h"

@implementation AccountRequestBuilder

- (NSDictionary*)buildJsonForDecodeCookie:(NSString*)cookie appToken:(NSString*)appToken {
    return @{ @"applicationToken": [self getNonNilValueForString:appToken],
              @"cookie": [self getNonNilValueForString:cookie], };
}

- (NSDictionary*)buildJsonForActivateDevice:(NSString*)deviceId activationCode:(NSString*)code {
    return @{ @"deviceId": [self getNonNilValueForString:deviceId],
              @"activationCode": [self getNonNilValueForString:code], };
}

- (NSDictionary*)buildJsonForSendCode:(NSString*)deviceId {
    return @{ @"deviceId": [self getNonNilValueForString:deviceId], };
}

- (NSDictionary*)buildJsonForLogin:(NSString*)email userName:(NSString*)userName password:(NSString*)password
                           appName:(NSString*)appName deviceId:(NSString*)deviceId
                         pushToken:(NSString*)pushToken setCookie:(BOOL)setCookie appToken:(NSString*)appToken {
    
    // Create options NSDictionary
    NSDictionary *options = @{ @"appName": [self getNonNilValueForString:appName],
                               @"applicationToken": [self getNonNilValueForString:appToken],
                               @"deviceId": [self getNonNilValueForString:deviceId],
                               @"pushToken": [self getNonNilValueForString:pushToken],
                               @"setCookie": @(setCookie), };
    
    return @{ @"email": [self getNonNilValueForString:email],
              @"userName": (userName.length == 0) ? [NSNull null] : userName,
              @"password": [self getNonNilValueForString:password],
              @"options": options, };
}

- (NSDictionary*)buildJsonForRegisterDevice:(NSString*)deviceId phoneNumber:(NSString*)number {
    return @{ @"deviceId": [self getNonNilValueForString:deviceId],
              @"phoneNumber": [self getNonNilValueForString:number], };
}

- (NSDictionary*)buildJsonForResetPass:(NSString*)email {
    return @{ @"email": [self getNonNilValueForString:email], };
}

- (NSDictionary*)buildJsonForSetPass:(NSString*)newPassword oldPassword:(NSString*)oldPassword {
    return @{ @"oldPassword": [self getNonNilValueForString:oldPassword],
              @"newPassword": [self getNonNilValueForString:newPassword], };
}

- (NSDictionary*)buildJsonForSetPin:(NSString*)newPincode password:(NSString*)password {
    return @{ @"password": [self getNonNilValueForString:password],
              @"newPincode": [self getNonNilValueForString:newPincode], };
}

/**
 * Method to get non-nil NSString object
 * @param string NSString which shouldn't be nil
 */
-(NSString*)getNonNilValueForString:(NSString*)string {
    return (string == nil) ? @"" : string;
}

@end