//
//  RequestItem.h
//  UserManagementSDK
//
//  Created by Lev T on 03/02/16.
//  Copyright © 2016 Sapdan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestItemOld : NSObject

@property (strong, nonatomic) NSString *requestId;
@property (strong, nonatomic) NSDate *requestDate;
@property (strong, nonatomic) NSString *sourceAccountNumber;
@property (strong, nonatomic) NSString *targetAccountNumber;
@property (strong, nonatomic) NSString *sourceText;
@property (strong, nonatomic) NSString *targetText;
@property (strong, nonatomic) NSString *sourceAccountName;
@property (strong, nonatomic) NSString *targetAccountName;
@property bool isPush;
@property (strong, nonatomic) NSString *amount;
@property (strong, nonatomic) NSString *currencyISOCode;
@property bool isApproved;
@property (strong, nonatomic) NSDate *confirmDate;
@end