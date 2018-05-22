//
//  ShopModel.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Information about exact shop

#import <Foundation/Foundation.h>
#import "ShopLocation.h"

@interface Shop : NSObject

@property (retain, nonatomic) NSString *bannerLinkUrl;
@property (retain, nonatomic) NSString *bannerUrl;
@property (retain, nonatomic) NSMutableArray<ShopLocation*> *countries;
@property (retain, nonatomic) NSString *currencyIsoCode;
@property (retain, nonatomic) NSString *facebookUrl;
@property (retain, nonatomic) NSString *googlePlusUrl;
@property (retain, nonatomic) NSString *linkedinUrl;
@property (retain, nonatomic) NSString *locationsString;
@property (retain, nonatomic) NSString *logoUrl;
@property (retain, nonatomic) NSString *pinterestUrl;
@property (retain, nonatomic) NSMutableArray<ShopLocation*> *regions;
@property long shopId;
@property (retain, nonatomic) NSString *twitterUrl;
@property (retain, nonatomic) NSString *uiBaseColor;
@property (retain, nonatomic) NSString *vimeoUrl;
@property (retain, nonatomic) NSString *youtubeUrl;

@end
