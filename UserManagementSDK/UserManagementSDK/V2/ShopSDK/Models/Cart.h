//
//  Cart.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Information about exact cart

#import <Foundation/Foundation.h>
#import "Product.h"
#import "CartItem.h"

@interface Cart : NSObject
/*
 ToDoV2:
 installments and maxInstallments are String but should be unsignedByte
 */

/**
 * Initialize cart for exact merchant with exact currency
 *
 * @param currencyIso - currency ISO for the cart
 * @param merchantNumber - number of the merhchant for which cart is being created
 * @return cart object
 */
-(id)initWithCurrencyIso:(NSString *)currencyIso merchantNumber:(NSString *)merchantNumber;

@property double changedTotal;
@property (retain, nonatomic) NSString *checkoutUrl;
@property (retain, nonatomic) NSString *cookie;
@property (retain, nonatomic) NSString *currencyIso;
@property (retain, nonatomic) NSString *installments;
@property BOOL isChanged;
@property (retain, nonatomic) NSMutableArray<CartItem*> *items;
@property (retain, nonatomic) NSString *maxInstallments;
@property (retain, nonatomic) Merchant *merchant;
@property (retain, nonatomic) NSString *merchantReference;
@property long shopId;
@property double totalPrice;

/**
 * Call this method to add product to the cart
 *
 * @param product - product to add
 * @param stockId - stock id or 0 in case product doesn't have stocks
 * @param price - price of the product
 * @param amount - amount of pieces of this product to order
 * @return error text if any or "Success" message in case the product was successfully added to the cart
 */
-(NSString*)addProduct:(Product*)product stockId:(long)stockId price:(double)price amountToOrder:(int)amount;

@end
