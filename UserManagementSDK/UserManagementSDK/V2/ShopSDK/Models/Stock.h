//
//  Stock.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Information about exact product stock

#import <Foundation/Foundation.h>

@interface Stock : NSObject

@property long stockId;
@property (retain, nonatomic) NSArray<NSNumber*> *propertyIds;
@property int quantityAvailable;
@property (retain, nonatomic) NSString *sku;

@end
