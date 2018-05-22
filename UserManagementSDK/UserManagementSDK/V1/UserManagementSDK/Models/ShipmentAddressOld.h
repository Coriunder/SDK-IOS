//
//  Address.h
//  UserManagementSDK
//
//  Created by Lev T on 01/02/16.
//  Copyright © 2016 Sapdan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShipmentAddressOld : NSObject

@property (strong, nonatomic) NSString *addressId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *address1;
@property (strong, nonatomic) NSString *address2;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *postalCode;
@property (strong, nonatomic) NSString *stateIso;
@property (strong, nonatomic) NSString *countryIso;
@property (strong, nonatomic) NSString *comment;
@property BOOL isDefault;

@end