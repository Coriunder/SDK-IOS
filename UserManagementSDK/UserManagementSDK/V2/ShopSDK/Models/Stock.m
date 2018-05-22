//
//  Stock.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Information about exact product stock

#import "Stock.h"

@implementation Stock

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.stockId = 0;
        self.propertyIds = [NSMutableArray new];
        self.quantityAvailable = 0;
        self.sku = @"";
    }
    return self;
}

@end