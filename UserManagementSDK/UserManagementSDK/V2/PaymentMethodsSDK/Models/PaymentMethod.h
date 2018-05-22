//
//  PaymentMethod.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Payment method data

#import <Foundation/Foundation.h>
#import "Address.h"

@interface PaymentMethod : NSObject

@property (strong, nonatomic) NSString *accountValue1;
@property (strong, nonatomic) NSString *accountValue2;
@property (strong, nonatomic) Address *address;
@property (strong, nonatomic) NSString *display;
@property (strong, nonatomic) NSDate *expirationDate;
@property long paymentMethodId;
@property (strong, nonatomic) NSString *iconURL;
@property BOOL isDefault;
@property (strong, nonatomic) NSString *issuerCountryIsoCode;
@property (strong, nonatomic) NSString *last4Digits;
@property (strong, nonatomic) NSString *ownerName;
@property (strong, nonatomic) NSString *paymentMethodGroupKey;
@property (strong, nonatomic) NSString *paymentMethodKey;
@property (strong, nonatomic) NSString *title;

@end