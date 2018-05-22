//
//  PaymentMethod.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Payment method data

#import "PaymentMethod.h"

@implementation PaymentMethod

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.accountValue1 = @"";
        self.accountValue2 = @"";
        self.address = [Address new];
        self.display = @"";
        self.expirationDate = [NSDate new];
        self.paymentMethodId = 0;
        self.iconURL = @"";
        self.isDefault = NO;
        self.issuerCountryIsoCode = @"";
        self.last4Digits = @"";
        self.ownerName = @"";
        self.paymentMethodGroupKey = @"";
        self.paymentMethodKey = @"";
        self.title = @"";
    }
    return self;
}

@end