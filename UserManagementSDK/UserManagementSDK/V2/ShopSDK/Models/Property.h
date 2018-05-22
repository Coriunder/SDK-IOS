//
//  Property.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Information about product property

#import <Foundation/Foundation.h>

@interface Property : NSObject

@property long propertyId;
@property (retain, nonatomic) NSString *propertyText;
@property (retain, nonatomic) NSString *propertyType;
@property (retain, nonatomic) NSString *propertyValue;
@property (retain, nonatomic) NSMutableArray<Property*> *subproperties;

@end
