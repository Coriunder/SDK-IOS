//
//  PaymentCardSubrootGroup.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Sub root group for payment method types

#import <Foundation/Foundation.h>
#import "BasicModel.h"

@interface PaymentCardSubrootGroup : BasicModel

@property (strong, nonatomic) NSString *groupKey;
@property BOOL hasExpirationDate;
@property (strong, nonatomic) NSString *value1Caption;
@property (strong, nonatomic) NSString *value1ValidationRegex;
@property (strong, nonatomic) NSString *value2Caption;
@property (strong, nonatomic) NSString *value2ValidationRegex;

@end