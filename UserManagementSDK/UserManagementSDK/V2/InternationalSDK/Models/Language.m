//
//  Language.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Information about language

#import "Language.h"

@implementation Language

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