//
//  BillingAddress.h
//  UserManagementSDK
//
//  Created by Lev T on 08/02/16.
//  Copyright © 2016 Sapdan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BillingAddressOld : NSObject

@property (strong, nonatomic) NSString *address1;
@property (strong, nonatomic) NSString *address2;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *zipcode;
@property (strong, nonatomic) NSString *stateIso;
@property (strong, nonatomic) NSString *countryIso;

@end