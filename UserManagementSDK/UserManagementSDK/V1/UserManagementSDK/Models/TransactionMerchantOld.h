//
//  TransactionMerchant.h
//  UserManagementSDK
//
//  Created by Lev T on 09/02/16.
//  Copyright © 2016 Sapdan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransactionMerchantOld : NSObject

@property (retain, nonatomic) NSString *number;
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *email;
@property (retain, nonatomic) NSString *phone;
@property (retain, nonatomic) NSString *address1;
@property (retain, nonatomic) NSString *address2;
@property (retain, nonatomic) NSString *city;
@property (retain, nonatomic) NSString *countryIso;
@property (retain, nonatomic) NSString *stateIso;
@property (retain, nonatomic) NSString *zipCode;
@property (retain, nonatomic) NSString *website;
@property (retain, nonatomic) NSString *logoUrl;

@end