//
//  Cart.m
//  UserManagementSDK
//
//  Created by Lev T on 04/02/16.
//  Copyright © 2016 Sapdan. All rights reserved.
//

#import "CartOld.h"
#import "CartItemOld.h"
#import "StockOld.h"

@implementation CartOld

-(void)addProduct:(ProductOld*)product stockId:(long)stockId price:(NSString*)price amountToOrder:(long)amount callback:(void (^)(bool success, NSString* message))callback {
    
    if (product == nil) {
        if (callback) callback(NO, @"Attempt to add an empty product");
        return;
    }
    
    if (product.merchant!=nil && self.merchant!=nil && ![product.merchant.number isEqualToString:self.merchant.number]) {
        if (callback) callback(NO, @"Attempt to add product to the cart of another merchant");
        return;
    }
    
    if (amount < 1) {
        if (callback) callback(NO, @"Amount is too small. There is nothing to add.");
        return;
    }
    
    //Check whether stock is correct
    StockOld *currentStock = nil;
    if (product.stocks != nil && product.stocks.count > 0) {
        for (StockOld *stock in product.stocks) {
            if (stock.stockId == stockId) {
                currentStock = stock;
                break;
            }
        }
        if (currentStock == nil) {
            if (callback) callback(NO, @"Attempt to send wrong stock");
            return;
        }
    }
    
    if (self.shopCartItems== nil) self.shopCartItems = [[NSMutableArray alloc]init];
    
    //Check for duplicates and different dynamic prices
    CartItemOld *duplicatedItem = nil;
    int duplicatedItemPosition = 0;
    for (int i = 0; i < self.shopCartItems.count; i++) {
        CartItemOld *shopCartItem = [self.shopCartItems objectAtIndex:i];
        if ([shopCartItem.itemProductId isEqual:product.productId] &&
            (!product.isDynamicAmount || (product.isDynamicAmount && [price floatValue] == [shopCartItem.itemPrice floatValue])) &&
            (stockId == shopCartItem.itemProductStockId)) {
            //same item with same price detected
            duplicatedItem = shopCartItem;
            duplicatedItemPosition = i;
            break;
        }
    }
    
    NSInteger previousQuantity = 0;
    if (duplicatedItem != nil) previousQuantity = [duplicatedItem.itemQuantity integerValue];
    NSInteger resultQuantity = previousQuantity + amount;
    
    if (resultQuantity < [product.stepQuantity integerValue] || (resultQuantity > [product.stepQuantity integerValue] && (resultQuantity%[product.stepQuantity integerValue]) != 0)) {
        ///Wrong step for quantity
        if (callback)
            callback(NO, [NSString stringWithFormat:@"Wrong product quantity. Product quantity should be divisible by step quantity (%@ items for this product)", product.stepQuantity]);
        return;
    }
    
    if ([product.maxQuantity integerValue] < resultQuantity) {
        //Maximum quantity exceeded.
        if (callback)
            callback(NO, [NSString stringWithFormat:@"Maximum quantity for the product %@ is %@. You already have %ld such products in the cart. Can't add %ld more such products. Maximum quantity to add is %ld.", product.name, product.maxQuantity, previousQuantity, amount, ([product.maxQuantity integerValue] - previousQuantity)]);
        return;
    }
    
    if ([product.quantity integerValue] < resultQuantity) {
        //Available quantity exceeded.
        if (callback)
            callback(NO, [NSString stringWithFormat:@"Available quantity for the product %@ is %@. You already have %ld such products in the cart. Can't add %ld more such products. Available quantity to add is %ld.", product.name, product.quantity, previousQuantity, amount, ([product.quantity integerValue] - previousQuantity)]);
        return;
    }
    
    if (currentStock != nil && currentStock.stockQuantity < resultQuantity) {
        //Available stock quantity exceeded.
        if (callback)
            callback(NO, [NSString stringWithFormat:@"Available quantity for this stock of the product %@ is %ld. You already have %ld such products in the cart. Can't add %ld more such products. Available quantity to add is %ld.", product.name, currentStock.stockQuantity, previousQuantity, amount, (currentStock.stockQuantity - previousQuantity)]);
        return;
    }
    
    
    if (duplicatedItem != nil) {
        //This item is already in the cart, update it
        duplicatedItem.itemQuantity = [NSString stringWithFormat:@"%ld", resultQuantity];
        duplicatedItem.itemTotalProduct = duplicatedItem.itemTotalProduct + [price doubleValue]*amount;
        [self.shopCartItems removeObjectAtIndex:duplicatedItemPosition];
        [self.shopCartItems insertObject:duplicatedItem atIndex:duplicatedItemPosition];
        
    } else {
        //This item is new, add it
        CartItemOld *itemToAdd = [[CartItemOld alloc] init];
        itemToAdd.itemProductId = product.productId;
        if (currentStock != nil) itemToAdd.itemProductStockId = stockId;
        itemToAdd.itemName = product.name;
        itemToAdd.itemQuantity = [NSString stringWithFormat:@"%ld",amount];
        itemToAdd.itemPrice = price;
        itemToAdd.itemCurrencyIsoCode = product.currencyISOCode;
        itemToAdd.itemTotalProduct = [price doubleValue]*amount;
        itemToAdd.itemMinQuantity = product.minQuantity;
        itemToAdd.itemMaxQuantity = product.maxQuantity;
        itemToAdd.itemStepQuantity = product.stepQuantity;
        itemToAdd.itemImageUrl = product.imageUrl;
        [self.shopCartItems addObject:itemToAdd];
    }
     
    self.cartMerchantReference = product.merchant.website;
    self.cartCurrencyIso = product.currencyISOCode;
    self.totalPrice = [NSString stringWithFormat:@"%0.2f",([self.totalPrice doubleValue] + [price doubleValue]*amount)];
    
    if (callback) callback(YES, @"Success");
}

@end