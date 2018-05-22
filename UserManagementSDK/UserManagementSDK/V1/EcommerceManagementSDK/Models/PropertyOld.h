//
//  Property.h
//  UserManagementSDK
//
//  Created by Lev T on 04/02/16.
//  Copyright © 2016 Sapdan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PropertyOld : NSObject

@property long propertyId;
@property (retain, nonatomic) NSString *propertyText;
@property (retain, nonatomic) NSString *propertyType;
@property (retain, nonatomic) NSString *propertyValue;
@property (retain, nonatomic) NSMutableArray *subproperties;

@end