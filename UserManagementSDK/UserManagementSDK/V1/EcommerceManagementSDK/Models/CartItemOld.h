//
//  CartItem.h
//  UserManagementSDK
//
//  Created by Lev T on 04/02/16.
//  Copyright © 2016 Sapdan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartItemOld : NSObject

@property (retain, nonatomic) NSString *itemId;
@property (retain, nonatomic) NSString *itemProductId;
@property long itemProductStockId;
@property (retain, nonatomic) NSString *itemImageUrl;
@property (retain, nonatomic) NSDate *itemInsertDate;
@property (retain, nonatomic) NSString *itemName;
@property (retain, nonatomic) NSString *itemQuantity;
@property (retain, nonatomic) NSString *itemPrice;
@property (retain, nonatomic) NSString *itemCurrencyIsoCode;
@property (retain, nonatomic) NSString *itemCurrencyFxRate;
@property (retain, nonatomic) NSString *itemType;
@property (retain, nonatomic) NSString *itemDownloadMediaType;
@property (retain, nonatomic) NSString *itemShippingFee;
@property (retain, nonatomic) NSString *itemVATPercent;
@property (retain, nonatomic) NSString *itemTotalShipping;
@property double itemTotalProduct;
@property (retain, nonatomic) NSString *itemTotal;
@property (retain, nonatomic) NSString *itemMinQuantity;
@property (retain, nonatomic) NSString *itemMaxQuantity;
@property (retain, nonatomic) NSString *itemStepQuantity;
@property (retain, nonatomic) NSString *itemQuantityAvailable;
@property (retain, nonatomic) NSMutableArray *itemProperties;
@property bool itemIsAvailable;
@property (retain, nonatomic) NSString *itemReceiptLink;
@property (retain, nonatomic) NSString *itemReceiptText;
@property (retain, nonatomic) NSString *itemGuestDownloadUrl;
@property bool itemIsChanged;
@property (retain, nonatomic) NSString *itemChangedPrice;
@property (retain, nonatomic) NSString *itemChangedCurrencyIso;
@property (retain, nonatomic) NSString *itemChangedTotal;

@end