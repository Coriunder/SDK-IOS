//
//  Identity.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Application identity data

#import <Foundation/Foundation.h>

@interface Identity : NSObject

@property (strong, nonatomic) NSString *brandName;
@property (strong, nonatomic) NSString *companyName;
@property (strong, nonatomic) NSString *copyrightText;
@property (strong, nonatomic) NSString *domainName;
@property BOOL isActive;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *theme;
@property (strong, nonatomic) NSString *urlDevCenter;
@property (strong, nonatomic) NSString *urlMerchantCP;
@property (strong, nonatomic) NSString *urlProcess;
@property (strong, nonatomic) NSString *urlWallet;
@property (strong, nonatomic) NSString *urlWebsite;

@end