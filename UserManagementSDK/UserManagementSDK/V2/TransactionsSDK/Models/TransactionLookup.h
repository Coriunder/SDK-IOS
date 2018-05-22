//
//  TransactionLookupInfo.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Brief information about transaction returned after lookup

#import <Foundation/Foundation.h>

@interface TransactionLookup : NSObject

@property (retain, nonatomic) NSString *merchantName;
@property (retain, nonatomic) NSString *merchantSupportEmail;
@property (retain, nonatomic) NSString *merchantSupportPhone;
@property (retain, nonatomic) NSString *merchantWebSite;
@property (retain, nonatomic) NSString *methodString;
@property (retain, nonatomic) NSDate *transactionDate;
@property long transactionID;

@end