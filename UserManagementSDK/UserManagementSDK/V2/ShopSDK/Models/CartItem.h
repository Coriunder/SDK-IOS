//
//  CartItem.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Information about exact cart item

#import <Foundation/Foundation.h>
#import "Property.h"

@interface CartItem : NSObject
/*
 ToDoV2:
 type is String but should be unsignedByte
 */

@property (retain, nonatomic) NSString *changedCurrencyIso;
@property double changedPrice;
@property double changedTotal;
@property double currencyFxRate;
@property (retain, nonatomic) NSString *currencyIsoCode;
@property (retain, nonatomic) NSString *downloadMediaType;
@property (retain, nonatomic) NSString *guestDownloadUrl;
@property long itemId;
@property (retain, nonatomic) NSDate *insertDate;
@property BOOL isAvailable;
@property BOOL isChanged;
@property (retain, nonatomic) NSMutableArray<Property*> *itemProperties;
@property int maxQuantity;
@property int minQuantity;
@property (retain, nonatomic) NSString *name;
@property double price;
@property long productId;
@property (retain, nonatomic) NSString *imageUrl;
@property long productStockId;
@property int quantity;
@property (retain, nonatomic) NSString *receiptLink;
@property (retain, nonatomic) NSString *receiptText;
@property double shippingFee;
@property int stepQuantity;
@property double total;
@property double totalProduct;
@property double totalShipping;
@property (retain, nonatomic) NSString *type;
@property double vatPercent;

@end
