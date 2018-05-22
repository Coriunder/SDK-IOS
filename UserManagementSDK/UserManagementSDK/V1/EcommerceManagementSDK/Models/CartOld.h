//
//  Cart.h
//  UserManagementSDK
//
//  Created by Lev T on 04/02/16.
//  Copyright © 2016 Sapdan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MerchantOld.h"
#import "ProductOld.h"

@interface CartOld : NSObject

@property (retain, nonatomic) NSString *cartId;
@property (retain, nonatomic) NSString *cartCookie;
@property (retain, nonatomic) NSMutableArray *shopCartItems;
@property (retain, nonatomic) NSString *totalPrice;
@property (retain, nonatomic) NSString *cartCurrencyIso;
@property (retain, nonatomic) NSString *cartCheckoutUrl;
@property (retain, nonatomic) NSString *cartMerchantReference;
@property (retain, nonatomic) NSString *cartWalletCredentials;
@property (retain, nonatomic) MerchantOld *merchant;
@property (retain, nonatomic) NSString *installments;
@property (retain, nonatomic) NSString *maxInstallments;
@property bool cartIsChanged;
@property (retain, nonatomic) NSString *cartChangedTotal;

-(void)addProduct:(ProductOld*)product stockId:(long)stockId price:(NSString*)price amountToOrder:(long)amount callback:(void (^)(bool success, NSString* message))callback;

@end