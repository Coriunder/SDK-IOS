//
//  ProductCategory.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Information about product category

#import <Foundation/Foundation.h>

@interface ProductCategory : NSObject

@property int categoryId;
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSMutableArray<ProductCategory*> *subcategories;

@end
