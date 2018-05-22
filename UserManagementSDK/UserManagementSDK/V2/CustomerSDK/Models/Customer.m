//
//  CustomerInfo.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Information about logged in user

#import "Customer.h"

@implementation Customer

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.address = [Address new];
        self.cellNumber = @"";
        self.customerNumber = @"";
        self.dateOfBirth = [NSDate new];
        self.email = @"";
        self.firstName = @"";
        self.lastName = @"";
        self.personalNumber = @"";
        self.phone = @"";
        self.userImage = nil;
        self.profileImageSize = 0;
        self.registrationDate = [NSDate new];
    }
    return self;
}

@end