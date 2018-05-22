//
//  Merchant.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Information about the merchant

#import <Foundation/Foundation.h>
#import "Address.h"

@interface Merchant : NSObject

@property (retain, nonatomic) Address *address;
@property (retain, nonatomic) NSArray *currencies;
@property (retain, nonatomic) NSString *email;
@property (retain, nonatomic) NSString *faxNumber;
@property (retain, nonatomic) NSString *group;
@property (retain, nonatomic) NSArray *languages;
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *number;
@property (retain, nonatomic) NSString *phone;
@property (retain, nonatomic) NSString *website;

@end