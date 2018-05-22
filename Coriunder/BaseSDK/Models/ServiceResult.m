//
//  ServiceResult.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Common service response data

#import "ServiceResult.h"

@implementation ServiceResult

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.code = 0;
        self.isSuccess = NO;
        self.key = @"";
        self.message = @"";
        self.number = @"";
    }
    return self;
}

@end