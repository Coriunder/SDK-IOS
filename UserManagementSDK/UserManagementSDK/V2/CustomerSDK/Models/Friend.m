//
//  Friend.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Information about other user's account

#import "Friend.h"

@implementation Friend

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.userId = @"";
        self.fullName = @"";
        self.profileImage = nil;
        self.relationType = 0;
    }
    return self;
}

@end