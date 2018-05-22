//
//  BasicModel.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Commonly used data structure.
//  Extended by Country, Language, State, PaymentCardRootGroup, PaymentCartSubRootGroup models

#import <Foundation/Foundation.h>

@interface BasicModel : NSObject

@property (strong, nonatomic) NSString *icon;
@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *name;

@end