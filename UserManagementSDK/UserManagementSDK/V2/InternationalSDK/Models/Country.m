//
//  Country.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Information about country

#import "Country.h"

@implementation Country

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.icon = @"";
        self.key = @"";
        self.name = @"";
    }
    return self;
}

@end