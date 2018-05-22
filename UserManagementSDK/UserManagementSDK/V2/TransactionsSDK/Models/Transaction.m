//
//  TransactionInfo.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Information about exact transaction

#import "Transaction.h"

@implementation Transaction

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.amount = 0;
        self.authCode = @"";
        self.comment = @"";
        self.currencyIso = @"";
        self.transactionId = 0;
        self.insertDate = [NSDate new];
        self.installments = 0;
        self.isManual = NO;
        self.isRefunded = NO;
        self.merchant = [Merchant new];
        self.payerEmail = @"";
        self.payerFullName = @"";
        self.payerPhone = @"";
        self.payerShippingAddress = [Address new];
        self.paymentDataBillingAddress = [Address new];
        self.paymentDataBin = @"";
        self.paymentDataBinCountry = @"";
        self.paymentDataExpirationMonth = 0;
        self.paymentDataExpirationYear = 0;
        self.paymentDataLast4 = @"";
        self.paymentDataType = @"";
        self.paymentDisplay = @"";
        self.paymentMethodGroupKey = @"";
        self.paymentMethodKey = @"";
        self.receiptLink = @"";
        self.receiptText = @"";
        self.text = @"";
    }
    return self;
}

@end