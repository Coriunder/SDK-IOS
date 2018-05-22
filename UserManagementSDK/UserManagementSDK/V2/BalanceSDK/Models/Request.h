//
//  RequestItem.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Information about a transaction request

#import <Foundation/Foundation.h>

@interface Request : NSObject

@property double amount;
@property (strong, nonatomic) NSDate *confirmDate;
@property (strong, nonatomic) NSString *currencyISOCode;
@property long requestId;
@property BOOL isApproved;
@property BOOL isPush;
@property (strong, nonatomic) NSDate *requestDate;
@property long sourceAccountId;
@property (strong, nonatomic) NSString *sourceAccountName;
@property (strong, nonatomic) NSString *sourceText;
@property long targetAccountId;
@property (strong, nonatomic) NSString *targetAccountName;
@property (strong, nonatomic) NSString *targetText;

@end