//
//  ShippingAddress.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Information about shipping address

#import "ShippingAddress.h"

@implementation ShippingAddress

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
        self.comment = @"";
        self.addressId = 0;
        self.isDefault = NO;
        self.title = @"";
    }
    return self;
}

@end