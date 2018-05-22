//
//  CurrencyRate.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Information about currency rate

#import "CurrencyRate.h"

@implementation CurrencyRate

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.key = @"";
        self.value = 0;
    }
    return self;
}

@end
