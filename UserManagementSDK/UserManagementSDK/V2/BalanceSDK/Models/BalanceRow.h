//
//  BalanceRow.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Transactions' history item

#import <Foundation/Foundation.h>

@interface BalanceRow : NSObject

@property double amount;
@property (strong, nonatomic) NSString *currencyIso;
@property long balanceRowId;
@property (strong, nonatomic) NSDate *insertDate;
@property BOOL isPending;
@property long sourceId;
@property (strong, nonatomic) NSString *sourceType;
@property (strong, nonatomic) NSString *text;
@property double total;

@end
