//
//  ShopModel.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Information about exact shop

#import "Shop.h"

@implementation Shop

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.bannerLinkUrl = @"";
        self.bannerUrl = @"";
        self.countries = [NSMutableArray new];
        self.currencyIsoCode = @"";
        self.facebookUrl = @"";
        self.googlePlusUrl = @"";
        self.linkedinUrl = @"";
        self.locationsString = @"";
        self.logoUrl = @"";
        self.pinterestUrl = @"";
        self.regions = [NSMutableArray new];
        self.shopId = 0;
        self.twitterUrl = @"";
        self.uiBaseColor = @"";
        self.vimeoUrl = @"";
        self.youtubeUrl = @"";
    }
    return self;
}

@end