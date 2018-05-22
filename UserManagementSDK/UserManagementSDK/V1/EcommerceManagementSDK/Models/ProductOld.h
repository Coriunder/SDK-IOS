//
//  Product.h
//  UserManagementSDK
//
//  Created by Lev T on 04/02/16.
//  Copyright © 2016 Sapdan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MerchantOld.h"

@interface ProductOld : NSObject

@property (retain, nonatomic) NSString *productId;
@property (retain, nonatomic) NSString *imageUrl;
@property (retain, nonatomic) NSString *insertDate;
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *prodDescription;
@property (retain, nonatomic) NSString *quantity;
@property (retain, nonatomic) NSString *price;
@property (retain, nonatomic) NSString *currencyISOCode;
@property (retain, nonatomic) NSString *minQuantity;
@property (retain, nonatomic) NSString *maxQuantity;
@property (retain, nonatomic) NSString *stepQuantity;
@property (retain, nonatomic) NSString *type;
@property (retain, nonatomic) NSString *sku;
@property (retain, nonatomic) NSString *productUrl;
@property (retain, nonatomic) NSString *metaTitle;
@property (retain, nonatomic) NSString *metaDescription;
@property (retain, nonatomic) NSString *metaKeywords;
@property BOOL isDynamicAmount;

@property (retain, nonatomic) NSMutableArray *properties;
@property (retain, nonatomic) NSMutableArray *stocks;
@property (retain, nonatomic) NSMutableArray *categories;
@property (retain, nonatomic) NSMutableArray *paymentMethods;
@property (retain, nonatomic) NSString *cookie;

@property (retain, nonatomic) MerchantOld *merchant;

@end