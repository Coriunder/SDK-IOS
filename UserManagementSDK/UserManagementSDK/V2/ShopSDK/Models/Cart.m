//
//  Cart.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Information about exact cart

#import "Cart.h"

@implementation Cart

-(id)initWithCurrencyIso:(NSString *)currencyIso merchantNumber:(NSString *)merchantNumber {
    self = [self init];
    if (self) {
        self.currencyIso = currencyIso;
        [self.merchant setNumber:merchantNumber];
    }
    return self;
}

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.changedTotal = 0;
        self.checkoutUrl = @"";
        self.cookie = nil;
        self.currencyIso = @"";
        self.self.installments = @"0";
        self.isChanged = NO;
        self.items = [NSMutableArray new];
        self.maxInstallments = @"0";
        self.merchant = [Merchant new];
        self.merchantReference = @"";
        self.shopId = 0;
        self.totalPrice = 0;
    }
    return self;
}

-(NSString*)addProduct:(Product*)product stockId:(long)stockId price:(double)price amountToOrder:(int)amount {
    // Check whether data sent to the method is correct
    if (product == nil) return NSLocalizedStringFromTable(@"CartEmptyProduct", @"CoriunderStrings", @"");
    if (amount < 1) return NSLocalizedStringFromTable(@"CartSmallAmount", @"CoriunderStrings", @"");
    
    // Check whether product and the cart have same merchant
    if (product.merchant!=nil && self.merchant!=nil && ![product.merchant.number isEqualToString:self.merchant.number])
        return NSLocalizedStringFromTable(@"CartWrongMerchantCart", @"CoriunderStrings", @"");
    
    // In case product has stocks check whether stock is correct
    Stock *currentStock = nil;
    if (product.stocks != nil && product.stocks.count > 0) {
        for (Stock *stock in product.stocks) {
            if (stock.stockId == stockId) {
                // Stock was found
                currentStock = stock;
                break;
            }
        }
        
        // (currentStock == nil) means that such stock wasn't found
        if (currentStock == nil) return NSLocalizedStringFromTable(@"CartWrongStock", @"CoriunderStrings", @"");
    }
    
    // Creating new items' array in case cart's items' array is nil
    if (self.items == nil) self.items = [[NSMutableArray alloc]init];
    
    // Check for duplicates and different dynamic prices
    CartItem *duplicatedItem = nil;
    int duplicatedItemPosition = 0;
    for (int i = 0; i < self.items.count; i++) {
        CartItem *shopCartItem = [self.items objectAtIndex:i];
        if (shopCartItem.productId == product.productId &&
            (!product.isDynamicAmount || (product.isDynamicAmount &&
                                          price - shopCartItem.price == 0)) &&
            (stockId == shopCartItem.productStockId)) {
            // Same item with same price detected
            duplicatedItem = shopCartItem;
            duplicatedItemPosition = i;
            break;
        }
    }
    
    // This is how many items similar to our product we have in the cart
    int previousQuantity = 0;
    if (duplicatedItem != nil) previousQuantity = duplicatedItem.quantity;
    // This is how many such items will be in the cart after we will add our product
    int resultQuantity = previousQuantity + amount;
    
    if (resultQuantity < product.quantityInterval ||
        (resultQuantity > product.quantityInterval && resultQuantity%product.quantityInterval != 0)) {
        // Wrong step quantity
        return [NSString stringWithFormat:NSLocalizedStringFromTable(@"CartWrongQuantity", @"CoriunderStrings", @""), product.quantityInterval];
    }
    
    if (product.quantityMax < resultQuantity) {
        // Maximum quantity exceeded.
        int availableQuantityToAdd = product.quantityMax - previousQuantity;
        return [NSString stringWithFormat:NSLocalizedStringFromTable(@"CartMaxQuantityExceeded", @"CoriunderStrings", @""), product.name, product.quantityMax, previousQuantity, amount, availableQuantityToAdd];
    }
    
    if (product.quantityAvailable < resultQuantity) {
        // Available quantity exceeded.
        int availableQuantityToAdd = product.quantityAvailable - previousQuantity;
        return [NSString stringWithFormat:NSLocalizedStringFromTable(@"CartAvailableQuantityExceeded", @"CoriunderStrings", @""), product.name, product.quantityAvailable, previousQuantity, amount, availableQuantityToAdd];
    }
    
    if (currentStock != nil && currentStock.quantityAvailable < resultQuantity) {
        // Available stock quantity exceeded.
        int availableQuantityToAdd = currentStock.quantityAvailable - previousQuantity;
        return [NSString stringWithFormat:NSLocalizedStringFromTable(@"CartAvailableStockQuantityExceeded", @"CoriunderStrings", @""), product.name, currentStock.quantityAvailable, previousQuantity, amount, availableQuantityToAdd];
    }
    
    if (duplicatedItem != nil) {
        // We already have similar product in the cart; update it
        duplicatedItem.quantity = resultQuantity;
        duplicatedItem.totalProduct = duplicatedItem.totalProduct + price*amount;
        [self.items removeObjectAtIndex:duplicatedItemPosition];
        [self.items insertObject:duplicatedItem atIndex:duplicatedItemPosition];
        
    } else {
        // We don't have similar products in the cart; add product
        CartItem *itemToAdd = [[CartItem alloc] init];
        itemToAdd.productId = product.productId;
        if (currentStock != nil) itemToAdd.productStockId = stockId;
        itemToAdd.name = product.name;
        itemToAdd.quantity = amount;
        itemToAdd.price = price;
        itemToAdd.currencyIsoCode = product.currencyIso;
        itemToAdd.totalProduct = price*amount;
        itemToAdd.minQuantity = product.quantityMin;
        itemToAdd.maxQuantity = product.quantityMax;
        itemToAdd.stepQuantity = product.quantityInterval;
        itemToAdd.imageUrl = product.imageURL;
        [self.items addObject:itemToAdd];
    }
    
    // Update other cart's data
    self.merchantReference = product.merchant.website;
    self.currencyIso = product.currencyIso;
    self.totalPrice = self.totalPrice + price*amount;
    
    return NSLocalizedStringFromTable(@"CartSuccess", @"CoriunderStrings", @"");
}

@end
