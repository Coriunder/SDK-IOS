//
//  LoginResult.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Login result data

#import <Foundation/Foundation.h>
#import "ServiceResult.h"

@interface LoginResult : ServiceResult

@property (strong, nonatomic) NSString *credentialsHeader;
@property (strong, nonatomic) NSString *credentialsToken;
@property (strong, nonatomic) NSString *encodedCookie;
@property BOOL isDeviceActivated;
@property BOOL isDeviceBlocked;
@property BOOL isDeviceRegistered;
@property BOOL isDeviceRegistrationRequired;
@property BOOL isFirstLogin;
@property (strong, nonatomic) NSDate *lastLogin;
@property BOOL versionUpdateRequired;

@end