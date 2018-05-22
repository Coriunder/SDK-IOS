//
//  Transaction.h
//  UserManagementSDK
//
//  Created by Lev T on 02/02/16.
//  Copyright © 2016 Sapdan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShipmentAddressOld.h"
#import "BillingAddressOld.h"
#import "TransactionMerchantOld.h"

@interface TransactionOld : NSObject

@property (strong, nonatomic) NSString *transactionId;
@property (strong, nonatomic) NSString *paymentMethodKey;
@property (strong, nonatomic) NSString *paymentMethodGroupKey;
@property (strong, nonatomic) NSString *autoCode;
@property (strong, nonatomic) NSString *amount;
@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSDate *insertDate;
@property (strong, nonatomic) NSString *currencyIso;
@property (strong, nonatomic) NSString *comment;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSString *receiptText;
@property (strong, nonatomic) NSString *receiptLink;

@property (strong, nonatomic) TransactionMerchantOld *merchant;
@property (strong, nonatomic) ShipmentAddressOld *shippingAddress;
@property (strong, nonatomic) BillingAddressOld *billingAddress;

@end
