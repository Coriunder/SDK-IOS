//
//  BalanceRow.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Transactions' history item

#import "BalanceRow.h"

@implementation BalanceRow

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.amount = 0;
        self.currencyIso = @"";
        self.balanceRowId = 0;
        self.insertDate = [NSDate new];
        self.isPending = NO;
        self.sourceId = 0;
        self.sourceType = @"";
        self.text = @"";
        self.total = 0;
    }
    return self;
}

@end
