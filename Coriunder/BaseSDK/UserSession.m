//
//  UserSession.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Class which holds data about the user's session and deals with it

#import "UserSession.h"

@implementation UserSession

static UserSession *_instance = nil;

+ (UserSession *)getInstance {
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [UserSession new];
        }
    }
    return _instance;
}

- (void)resetSession {
    // Send invalid session notification
    [[NSNotificationCenter defaultCenter] postNotificationName:@"coriunderSessionInvalid" object:nil];
    // Clear session data
    self.credentialsToken = nil;
    self.credentialsHeader = nil;
    _instance = nil;
}

@end
