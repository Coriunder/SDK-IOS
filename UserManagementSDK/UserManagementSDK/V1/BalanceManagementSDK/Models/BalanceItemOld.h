//
//  BalanceItem.h
//  UserManagementSDK
//
//  Created by Lev T on 03/02/16.
//  Copyright © 2016 Sapdan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BalanceItemOld : NSObject

@property (strong, nonatomic) NSString *currencyIso;
@property (strong, nonatomic) NSString *amount;
@property (strong, nonatomic) NSString *total;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *sourceId;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *sourceType;
@property (strong, nonatomic) NSString *balanceRowId;
@property BOOL isPending;

@end