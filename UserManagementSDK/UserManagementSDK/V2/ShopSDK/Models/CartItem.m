//
//  CartItem.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Information about exact cart item

#import "CartItem.h"

@implementation CartItem

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.changedCurrencyIso = @"";
        self.changedPrice = 0;
        self.changedTotal = 0;
        self.currencyFxRate = 0;
        self.currencyIsoCode = @"";
        self.downloadMediaType = @"";
        self.guestDownloadUrl = @"";
        self.itemId = 0;
        self.insertDate = [NSDate new];
        self.isAvailable = false;
        self.isChanged = false;
        self.itemProperties = [NSMutableArray new];
        self.maxQuantity = 0;
        self.minQuantity = 0;
        self.name = @"";
        self.price = 0;
        self.productId = 0;
        self.imageUrl = @"";
        self.productStockId = 0;
        self.quantity = 0;
        self.receiptLink = @"";
        self.receiptText = @"";
        self.shippingFee = 0;
        self.stepQuantity = 0;
        self.total = 0;
        self.totalProduct = 0;
        self.totalShipping = 0;
        self.type = @"";
        self.vatPercent = 0;
    }
    return self;
}

@end