//
//  AccountParser.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Parser methods for Account services

#import "AccountParser.h"

@implementation AccountParser

- (CookieDecodeResult*)parseCookieDecoder:(id)resultObject {
    CookieDecodeResult *result = [CookieDecodeResult new];
    NSDictionary *dict = [self getDictionary:@"d" from:resultObject];
    [result setCode:[self getInt:@"Code" from:dict]];
    [result setIsSuccess:[self getBool:@"IsSuccess" from:dict]];
    [result setKey:[self getString:@"Key" from:dict]];
    [result setMessage:[self getString:@"Message" from:dict]];
    [result setNumber:[self getString:@"Number" from:dict]];
    [result setEmail:[self getString:@"Email" from:dict]];
    [result setFullName:[self getString:@"FullName" from:dict]];
    return result;
}

- (LoginResult*)parseLoginResult:(id)resultObject {
    LoginResult *result = [LoginResult new];
    NSDictionary *dict = [self getDictionary:@"d" from:resultObject];
    [result setCode:[self getInt:@"Code" from:dict]];
    [result setIsSuccess:[self getBool:@"IsSuccess" from:dict]];
    [result setKey:[self getString:@"Key" from:dict]];
    [result setMessage:[self getString:@"Message" from:dict]];
    [result setNumber:[self getString:@"Number" from:dict]];
    [result setCredentialsHeader:[self getString:@"CredentialsHeaderName" from:dict]];
    [result setCredentialsToken:[self getString:@"CredentialsToken" from:dict]];
    [result setEncodedCookie:[self getString:@"EncodedCookie" from:dict]];
    [result setIsDeviceActivated:[self getBool:@"IsDeviceActivated" from:dict]];
    [result setIsDeviceBlocked:[self getBool:@"IsDeviceBlocked" from:dict]];
    [result setIsDeviceRegistered:[self getBool:@"IsDeviceRegistered" from:dict]];
    [result setIsDeviceRegistrationRequired:[self getBool:@"IsDeviceRegistrationRequired" from:dict]];
    [result setIsFirstLogin:[self getBool:@"IsFirstLogin" from:dict]];
    [result setLastLogin:[self getReadableDate:@"LastLogin" from:dict]];
    [result setVersionUpdateRequired:[self getBool:@"VersionUpdateRequired" from:dict]];
    return result;
}

@end
