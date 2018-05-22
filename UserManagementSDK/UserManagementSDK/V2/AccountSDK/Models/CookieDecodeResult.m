//
//  CookieDecodeResult.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Result of cookie decoding

#import "CookieDecodeResult.h"

@implementation CookieDecodeResult

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.code = 0;
        self.isSuccess = NO;
        self.key = @"";
        self.message = @"";
        self.number = @"";
        self.email = @"";
        self.fullName = @"";
    }
    return self;
}

@end