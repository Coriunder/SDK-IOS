//
//  TransactionLookupInfo.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Brief information about transaction returned after lookup

#import "TransactionLookup.h"

@implementation TransactionLookup

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.merchantName = @"";
        self.merchantSupportEmail = @"";
        self.merchantSupportPhone = @"";
        self.merchantWebSite = @"";
        self.methodString = @"";
        self.transactionDate = [NSDate new];
        self.transactionID = 0;
    }
    return self;
}

@end