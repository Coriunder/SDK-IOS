//
//  BalanceTotal.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Info about total balances

#import "BalanceTotal.h"

@implementation BalanceTotal

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.currencyIso = @"";
        self.current = 0;
        self.expected = 0;
        self.pending = 0;
    }
    return self;
}

@end