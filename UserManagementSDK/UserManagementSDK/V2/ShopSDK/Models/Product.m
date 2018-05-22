//
//  Product.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Information about exact product

#import "Product.h"

@implementation Product

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.categories = [NSMutableArray new];
        self.categoryId = 0;
        self.categoryName = @"";
        self.checkoutUrl = @"";
        self.currencyIso = @"";
        self.productDescription = @"";
        self.productId = 0;
        self.imageURL = @"";
        self.isDynamicAmount = false;
        self.isRecurring = false;
        self.merchant = [Merchant new];
        self.metaDescription = @"";
        self.metaKeywords = @"";
        self.metaTitle = @"";
        self.name = @"";
        self.nextProductId = 0;
        self.paymentMethods = [NSMutableArray new];
        self.previousProductId = 0;
        self.price = 0;
        self.productUrl = @"";
        self.properties = [NSMutableArray new];
        self.quantityAvailable = 0;
        self.quantityInterval = 0;
        self.quantityMax = 0;
        self.quantityMin = 0;
        self.recurringDisplay = @"";
        self.sku = @"";
        self.stocks = [NSMutableArray new];
        self.type = @"";
    }
    return self;
}

@end