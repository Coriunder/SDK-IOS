//
//  Address.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Base address info

#import "Address.h"

@implementation Address

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.address1 = @"";
        self.address2 = @"";
        self.city = @"";
        self.countryIso = @"";
        self.postalCode = @"";
        self.stateIso = @"";
    }
    return self;
}

@end