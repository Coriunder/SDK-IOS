//
//  TransactionInfo.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Information about exact transaction

#import <Foundation/Foundation.h>
#import "Address.h"
#import "Merchant.h"

@interface Transaction : NSObject

@property double amount;
@property (strong, nonatomic) NSString *authCode;
@property (strong, nonatomic) NSString *comment;
@property (strong, nonatomic) NSString *currencyIso;
@property long transactionId;
@property (strong, nonatomic) NSDate *insertDate;
@property int installments;
@property BOOL isManual;
@property BOOL isRefunded;
@property (strong, nonatomic) Merchant *merchant;
@property (strong, nonatomic) NSString *payerEmail;
@property (strong, nonatomic) NSString *payerFullName;
@property (strong, nonatomic) NSString *payerPhone;
@property (strong, nonatomic) Address *payerShippingAddress;
@property (strong, nonatomic) Address *paymentDataBillingAddress;
@property (strong, nonatomic) NSString *paymentDataBin;
@property (strong, nonatomic) NSString *paymentDataBinCountry;
@property int paymentDataExpirationMonth;
@property int paymentDataExpirationYear;
@property (strong, nonatomic) NSString *paymentDataLast4;
@property (strong, nonatomic) NSString *paymentDataType;
@property (strong, nonatomic) NSString *paymentDisplay;
@property (strong, nonatomic) NSString *paymentMethodGroupKey;
@property (strong, nonatomic) NSString *paymentMethodKey;
@property (strong, nonatomic) NSString *receiptLink;
@property (strong, nonatomic) NSString *receiptText;
@property (strong, nonatomic) NSString *text;

@end