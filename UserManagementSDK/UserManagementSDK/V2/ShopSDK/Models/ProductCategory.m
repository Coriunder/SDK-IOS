//
//  ProductCategory.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Information about product category

#import "ProductCategory.h"

@implementation ProductCategory

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.categoryId = 0;
        self.name = @"";
        self.subcategories = [NSMutableArray new];
    }
    return self;
}

@end