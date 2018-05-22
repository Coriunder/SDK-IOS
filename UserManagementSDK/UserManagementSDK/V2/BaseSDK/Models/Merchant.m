//
//  Merchant.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Information about the merchant

#import "Merchant.h"

@implementation Merchant

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.address = [Address new];
        self.currencies = [NSMutableArray new];
        self.email = @"";
        self.faxNumber = @"";
        self.group = @"";
        self.languages = [NSMutableArray new];
        self.name = @"";
        self.number = @"";
        self.phone = @"";
        self.website = @"";
    }
    return self;
}

@end