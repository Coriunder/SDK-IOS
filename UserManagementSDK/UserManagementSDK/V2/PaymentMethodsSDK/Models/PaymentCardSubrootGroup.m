//
//  PaymentCardSubrootGroup.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Sub root group for payment method types

#import "PaymentCardSubrootGroup.h"

@implementation PaymentCardSubrootGroup

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.icon = @"";
        self.key = @"";
        self.name = @"";
        self.groupKey = @"";
        self.hasExpirationDate = NO;
        self.value1Caption = @"";
        self.value1ValidationRegex = @"";
        self.value2Caption = @"";
        self.value2ValidationRegex = @"";
    }
    return self;
}

@end