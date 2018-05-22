//
//  ShopPlace.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Information about shop location

#import "ShopLocation.h"

@implementation ShopLocation

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.isoCode = @"";
        self.name = @"";
    }
    return self;
}

@end