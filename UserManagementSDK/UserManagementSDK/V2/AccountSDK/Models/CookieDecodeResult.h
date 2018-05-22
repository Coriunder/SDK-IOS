//
//  CookieDecodeResult.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Result of cookie decoding

#import <Foundation/Foundation.h>
#import "ServiceResult.h"

@interface CookieDecodeResult : ServiceResult
/*
 ToDoV2:
 excluded image
 */

@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *fullName;

@end