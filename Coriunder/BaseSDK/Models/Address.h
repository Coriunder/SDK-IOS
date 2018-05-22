//
//  Address.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Base address info

#import <Foundation/Foundation.h>

@interface Address : NSObject

@property (strong, nonatomic) NSString *address1;
@property (strong, nonatomic) NSString *address2;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *countryIso;
@property (strong, nonatomic) NSString *postalCode;
@property (strong, nonatomic) NSString *stateIso;

@end