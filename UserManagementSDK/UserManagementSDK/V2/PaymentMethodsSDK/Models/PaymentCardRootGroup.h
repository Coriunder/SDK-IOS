//
//  PaymentCardRootGroup.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Root group for payment method types

#import <Foundation/Foundation.h>
#import "BasicModel.h"
#import "PaymentCardSubrootGroup.h"

@interface PaymentCardRootGroup : BasicModel

@property (strong, nonatomic) NSMutableArray<PaymentCardSubrootGroup*> *subGroups;

@end
