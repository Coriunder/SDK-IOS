//
//  Product.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Information about exact product

#import <Foundation/Foundation.h>
#import "Merchant.h"
#import "ProductCategory.h"
#import "Property.h"
#import "Stock.h"

@interface Product : NSObject
/*
 ToDoV2:
 type is String but should be unsignedByte
 */

@property (retain, nonatomic) NSArray<ProductCategory*> *categories;
@property long categoryId;
@property (retain, nonatomic) NSString *categoryName;
@property (retain, nonatomic) NSString *checkoutUrl;
@property (retain, nonatomic) NSString *currencyIso;
@property (retain, nonatomic) NSString *productDescription;
@property long productId;
@property (retain, nonatomic) NSString *imageURL;
@property BOOL isDynamicAmount;
@property BOOL isRecurring;
@property (retain, nonatomic) Merchant *merchant;
@property (retain, nonatomic) NSString *metaDescription;
@property (retain, nonatomic) NSString *metaKeywords;
@property (retain, nonatomic) NSString *metaTitle;
@property (retain, nonatomic) NSString *name;
@property long nextProductId;
@property (retain, nonatomic) NSArray<NSNumber*> *paymentMethods;
@property long previousProductId;
@property double price;
@property (retain, nonatomic) NSString *productUrl;
@property (retain, nonatomic) NSMutableArray<Property*> *properties;
@property int quantityAvailable;
@property int quantityInterval;
@property int quantityMax;
@property int quantityMin;
@property (retain, nonatomic) NSString *recurringDisplay;
@property (retain, nonatomic) NSString *sku;
@property (retain, nonatomic) NSMutableArray<Stock*> *stocks;
@property (retain, nonatomic) NSString *type;

@end
