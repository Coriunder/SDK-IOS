//
//  Category.h
//  UserManagementSDK
//
//  Created by Lev T on 05/02/16.
//  Copyright © 2016 Sapdan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductCategoryOld : NSObject

@property (retain, nonatomic) NSString *categoryId;
@property (retain, nonatomic) NSString *categoryName;
@property (retain, nonatomic) NSMutableArray *subcategories;

@end