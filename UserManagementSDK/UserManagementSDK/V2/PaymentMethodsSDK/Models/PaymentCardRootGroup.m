//
//  PaymentCardRootGroup.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Root group for payment method types

#import "PaymentCardRootGroup.h"

@implementation PaymentCardRootGroup

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.icon = @"";
        self.key = @"";
        self.name = @"";
        self.subGroups = [NSMutableArray new];
    }
    return self;
}

@end