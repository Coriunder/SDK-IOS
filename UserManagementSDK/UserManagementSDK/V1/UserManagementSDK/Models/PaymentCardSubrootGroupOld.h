//
//  PaymentCardGroupSubrootModel.h

//
//  Created by v_stepanov on 15.01.15.
//  Copyright (c) 2015 OBL Computer Network. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentCardSubrootGroupOld : NSObject

@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *icon;
@property (strong, nonatomic) NSString *groupKey;
@property (strong, nonatomic) NSString *value1Caption;
@property (strong, nonatomic) NSString *value1ValidationRegex;
@property (strong, nonatomic) NSString *value2Caption;
@property (strong, nonatomic) NSString *value2ValidationRegex;
@property BOOL hasExpirationDate;

@end
