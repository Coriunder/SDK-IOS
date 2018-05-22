//
//  PaymentCardModel.h

//
//  Created by v_stepanov on 12.01.15.
//  Copyright (c) 2015 OBL Computer Network. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BillingAddressOld.h"

@interface PaymentMethodOld : NSObject

@property (strong, nonatomic) NSString *paymentMethodId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSDate *expirationDate;
@property (strong, nonatomic) NSString *iconURL;
@property BOOL isDefault;
@property (strong, nonatomic) NSString *ownerName;
@property (strong, nonatomic) NSString *paymentMethodGroupKey;
@property (strong, nonatomic) NSString *paymentMethodKey;
@property BOOL usesBillingAddress;
@property (strong, nonatomic) BillingAddressOld *address;
@property (strong, nonatomic) NSString *last4Digits;
@property (strong, nonatomic) NSString *issuerCountryIsoCode;
@property (strong, nonatomic) NSString *cardNumber;
@property (strong, nonatomic) NSString *accountValue2;

@end
