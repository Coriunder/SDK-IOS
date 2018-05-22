//
//  Identity.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Application identity data

#import "Identity.h"

@implementation Identity

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.brandName = @"";
        self.companyName = @"";
        self.copyrightText = @"";
        self.domainName = @"";
        self.isActive = NO;
        self.name = @"";
        self.theme = @"";
        self.urlDevCenter = @"";
        self.urlMerchantCP = @"";
        self.urlProcess = @"";
        self.urlWallet = @"";
        self.urlWebsite = @"";
    }
    return self;
}

@end