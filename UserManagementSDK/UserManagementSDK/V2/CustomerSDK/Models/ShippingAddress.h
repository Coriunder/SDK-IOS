//
//  ShippingAddress.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Information about shipping address

#import <Foundation/Foundation.h>
#import "Address.h"

@interface ShippingAddress : Address

@property (strong, nonatomic) NSString *comment;
@property long addressId;
@property BOOL isDefault;
@property (strong, nonatomic) NSString *title;

@end