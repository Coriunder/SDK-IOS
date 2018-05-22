//
//  Stock.h
//  UserManagementSDK
//
//  Created by Lev T on 04/02/16.
//  Copyright © 2016 Sapdan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockOld : NSObject

@property long stockId;
@property long stockQuantity;
@property (retain, nonatomic) NSString *sku;
@property (retain, nonatomic) NSArray *propertyIds;

@end