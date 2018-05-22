//
//  MerchantGroup.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Information about a merchant group

#import "MerchantGroup.h"

@implementation MerchantGroup

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.key = 0;
        self.value = @"";
    }
    return self;
}

@end
