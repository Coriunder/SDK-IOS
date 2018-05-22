//
//  RequestItem.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Information about a transaction request

#import "Request.h"

@implementation Request

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.amount = 0;
        self.confirmDate = [NSDate new];
        self.currencyISOCode = @"";
        self.requestId = 0;
        self.isApproved = NO;
        self.isPush = NO;
        self.requestDate = [NSDate new];
        self.sourceAccountId = 0;
        self.sourceAccountName = @"";
        self.sourceText = @"";
        self.targetAccountId = 0;
        self.targetAccountName = @"";
        self.targetText = @"";
    }
    return self;
}

@end