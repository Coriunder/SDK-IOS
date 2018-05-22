//
//  PaymentCardGroupModel.h

//
//  Created by v_stepanov on 14.01.15.
//  Copyright (c) 2015 OBL Computer Network. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentCardRootGroupOld : NSObject

@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *icon;
@property (strong, nonatomic) NSMutableArray *subGroups;

@end