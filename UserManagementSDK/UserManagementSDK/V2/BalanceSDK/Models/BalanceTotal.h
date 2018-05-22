//
//  BalanceTotal.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Info about total balances

#import <Foundation/Foundation.h>

@interface BalanceTotal : NSObject

@property (strong, nonatomic) NSString *currencyIso;
@property double current;
@property double expected;
@property double pending;

@end