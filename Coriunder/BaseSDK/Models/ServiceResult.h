//
//  ServiceResult.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Common service response data

#import <Foundation/Foundation.h>

@interface ServiceResult : NSObject

@property int code;
@property BOOL isSuccess;
@property (retain, nonatomic) NSString *key;
@property (retain, nonatomic) NSString *message;
@property (retain, nonatomic) NSString *number;

@end