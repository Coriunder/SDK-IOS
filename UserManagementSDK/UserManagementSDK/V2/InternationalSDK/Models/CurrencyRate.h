//
//  CurrencyRate.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Information about currency rate

#import <Foundation/Foundation.h>

@interface CurrencyRate : NSObject

@property (strong, nonatomic) NSString *key;
@property double value;

@end