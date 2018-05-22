//
//  Merchant.h
//  UserManagementSDK
//
//  Created by Lev T on 04/02/16.
//  Copyright © 2016 Sapdan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MerchantOld : NSObject

@property (retain, nonatomic) NSString *number;
@property (retain, nonatomic) NSString *name;

@property (retain, nonatomic) NSString *email;
@property (retain, nonatomic) NSString *phone;
@property (retain, nonatomic) NSString *fax;
@property (retain, nonatomic) NSString *address1;
@property (retain, nonatomic) NSString *address2;
@property (retain, nonatomic) NSString *city;
@property (retain, nonatomic) NSString *countryIso;
@property (retain, nonatomic) NSString *stateIso;
@property (retain, nonatomic) NSString *zipCode;

@property (retain, nonatomic) NSString *website;
@property (retain, nonatomic) NSString *group;
@property (retain, nonatomic) NSString *baseColor;
@property (retain, nonatomic) NSArray  *currencies;
@property (retain, nonatomic) NSString *bannerUrl;
@property (retain, nonatomic) NSString *bannerLinkUrl;
@property (retain, nonatomic) NSString *logoUrl;

@property (retain, nonatomic) NSString *twitterUrl;
@property (retain, nonatomic) NSString *googlePlusUrl;
@property (retain, nonatomic) NSString *vimeoUrl;
@property (retain, nonatomic) NSString *pinterestUrl;
@property (retain, nonatomic) NSString *youtubeUrl;
@property (retain, nonatomic) NSString *linkedinUrl;
@property (retain, nonatomic) NSString *facebookUrl;

@end