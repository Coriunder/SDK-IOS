//
//  Property.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Information about product property

#import "Property.h"

@implementation Property

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.propertyId = 0;
        self.propertyText = @"";
        self.propertyType = @"";
        self.propertyValue = @"";
        self.subproperties = [NSMutableArray new];
    }
    return self;
}

@end