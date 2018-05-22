//
//  ServiceMultiResult.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Common service response data

#import "ServiceMultiResult.h"

@implementation ServiceMultiResult

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.recordNumber = 0;
        self.refNumbers = [NSMutableArray new];
        self.code = 0;
        self.isSuccess = NO;
        self.key = @"";
        self.message = @"";
        self.number = @"";
    }
    return self;
}

@end