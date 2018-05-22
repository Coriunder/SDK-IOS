//
//  LoginResult.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Login result data

#import "LoginResult.h"

@implementation LoginResult

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.code = 0;
        self.isSuccess = NO;
        self.key = @"";
        self.message = @"";
        self.number = @"";
        self.credentialsHeader = @"";
        self.credentialsToken = @"";
        self.encodedCookie = @"";
        self.isDeviceActivated = NO;
        self.isDeviceBlocked = NO;
        self.isDeviceRegistered = NO;
        self.isDeviceRegistrationRequired = NO;
        self.isFirstLogin = NO;
        self.lastLogin = [NSDate new];
        self.versionUpdateRequired = NO;
    }
    return self;
}

@end