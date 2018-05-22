//
//  ServiceMultiResult.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Common service response data

#import <Foundation/Foundation.h>
#import "ServiceResult.h"

@interface ServiceMultiResult : ServiceResult

@property long recordNumber;
@property (retain, nonatomic) NSArray *refNumbers;

@end