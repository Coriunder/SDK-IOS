//
//  BalanceManagement.m
//  UserManagementSDK
//
//  Created by Lev T on 03/02/16.
//  Copyright © 2016 Sapdan. All rights reserved.
//

#import "BalanceManagement.h"
#import "UserManagement.h"
#import "BalanceItemOld.h"

@implementation BalanceManagement

static BalanceManagement *_instance = nil;

-(id)init {
    self = [super init];
    if (self) {
        self.plistName = @"BalanceManagementSetup";
    }
    return self;
}

+ (BalanceManagement *)getInstance {
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [BalanceManagement new];
        }
    }
    return _instance;
}

- (void)sendGetJsonRequestWithParameters:(NSDictionary *)params withMethod:(NSString *)method callback:(void (^)(BOOL success, id resultObject))completion {
    
    [self sendPostRequestWithParameters:params withMethod:method credentialsToken:[UserManagement getInstance].credentialsToken responseSerializer:responseJSON callback:completion];
}

/************************************ REQUESTS SECTION START ************************************/

- (void)getUserBalanceForCurrency:(NSString*)currencyIso includePending:(BOOL)includePending callback:(void (^)(bool success, NSString *balance, NSString* message))callback {
    
    if ([self isEmptyOrNil:currencyIso]) {
        if (callback) callback(NO, @"0", @"Attempt to send an empty value to the service");
        return;
    }
    
    NSDictionary *params = @{
                             @"currencyIsoCode":currencyIso,
                             @"includePending":@(includePending),
                             };
    [self sendGetJsonRequestWithParameters:params withMethod:@"GetTotal" callback:^(BOOL success, id resultObject) {
        if (success) {
            NSArray *result = [self getObject:@"d" from:resultObject];
            if (result != nil) {
                NSString *balance = @"0";
                if (result.count != 0) {
                    balance = [self getObject:@"Value" from:[result objectAtIndex:0]];
                    /*for (NSDictionary *oneTransactionDict in [resultObject objectForKey:@"d"]) {
                        NSString *iso = [oneTransactionDict objectForKey:@"CurrencyIso"];
                        float value = [[oneTransactionDict objectForKey:@"Value"] floatValue];
                    }*/
                }
                if (callback) callback(YES, balance, nil);
            } else {
                if (callback) callback(YES, @"0", nil);
            }
        } else {
            if (callback) callback(NO, @"0", ((NSError*)resultObject).localizedDescription);
        }
    }];
}

- (void)getTransactionsHistoryWithCurrency:(NSString*)currencyIso page:(int)page pageSize:(int)pageSize callback:(void (^)(bool success, NSMutableArray *balanceRows, NSString* message))callback {
    
    if ([self isEmptyOrNil:currencyIso]) {
        if (callback) callback(NO, nil, @"Attempt to send an empty value to the service");
        return;
    }
    
    NSDictionary *params = @{
                             @"Page": @(page),
                             @"PageSize": @(pageSize),
                             @"CurrencyIso": currencyIso,
                             };
    NSMutableDictionary *filterDict = [NSMutableDictionary new];
    [filterDict setObject:params forKey:@"filters"];
    
    [self sendGetJsonRequestWithParameters:filterDict withMethod:@"GetRows" callback:^(BOOL success, id resultObject) {
        if (success) {
            NSArray *result = [self getObject:@"d" from:resultObject];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            if (result != nil) {
                for (NSDictionary *dictinary in result) {
                    BalanceItemOld *item = [BalanceItemOld new];
                    item.currencyIso = [self getObject:@"CurrencyIso" from:dictinary];
                    item.amount = [self getObject:@"Amount" from:dictinary];
                    item.total = [self getObject:@"Total" from:dictinary];
                    item.text = [self getObject:@"Text" from:dictinary];
                    item.sourceId = [self getObject:@"SourceID" from:dictinary];
                    item.date = [self getReadableDate:[self getObject:@"InsertDate" from:dictinary]];
                    item.sourceType = [self getObject:@"SourceType" from:dictinary];
                    item.balanceRowId = [self getObject:@"ID" from:dictinary];
                    item.isPending = [[self getObject:@"IsPending" from:dictinary] boolValue];
                    [array addObject:item];
                }
                if (callback) callback(YES, array, nil);
            } else {
                if (callback) callback(YES, array, nil);
            }
        } else {
            if (callback) callback(NO, nil, ((NSError*)resultObject).localizedDescription);
        }
    }];
    
}

- (void)getRequestWithId:(NSInteger)requestId callback:(void (^)(bool success, RequestItemOld *request, NSString* message))callback {
    
    NSDictionary *params = @{ @"requestId":@(requestId), };
    
    [self sendGetJsonRequestWithParameters:params withMethod:@"GetRequest" callback:^(BOOL success, id resultObject) {
        if (success) {
            NSDictionary *result = [self getObject:@"d" from:resultObject];
            if (result != nil) {
                RequestItemOld *item = [self parseRequest:result];
                if (callback) callback(YES, item, nil);
            } else {
                if (callback) callback(NO, nil, @"No such item");
            }
        } else {
            if (callback) callback(NO, nil, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

- (void)getRequestsWithCurrency:(NSString*)currencyIso page:(int)page pageSize:(int)pageSize callback:(void (^)(bool success, NSMutableArray *requests, NSString* message))callback {
    
    if ([self isEmptyOrNil:currencyIso]) {
        if (callback) callback(NO, nil, @"Attempt to send an empty value to the service");
        return;
    }
    
    NSDictionary *params = @{
                             @"Page": @(page),
                             @"PageSize": @(pageSize),
                             @"CurrencyIso": currencyIso,
                             };
    NSMutableDictionary *filterDict = [NSMutableDictionary new];
    [filterDict setObject:params forKey:@"filters"];
    
    [self sendGetJsonRequestWithParameters:filterDict withMethod:@"GetRequests" callback:^(BOOL success, id resultObject) {
        if (success) {
            NSArray *result = [self getObject:@"d" from:resultObject];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            if (result != nil) {
                for (NSDictionary *dictinary in result) {
                    RequestItemOld *item = [self parseRequest:dictinary];
                    [array addObject:item];
                }
                if (callback) callback(YES, array, nil);
            } else {
                if (callback) callback(YES, array, nil);
            }
        } else {
            if (callback) callback(NO, nil, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

- (void)replyRequest:(NSInteger)requestId approve:(BOOL)approve pinCode:(NSString *)pinCode text:(NSString *)text callback:(void (^)(bool success, NSString* message))callback {
    
    if ([self isEmptyOrNil:pinCode]) {
        if (callback) callback(NO, @"Attempt to send an empty value to the service");
        return;
    }
    
    text = [self getNonNilValueForString:text];
    NSDictionary *params = @{
                             @"requestId": @(requestId),
                             @"approve": @(approve),
                             @"text": text,
                             @"pinCode": pinCode,
                             };
    [self sendGetJsonRequestWithParameters:params withMethod:@"ReplyRequest" callback:^(BOOL success, id resultObject) {
        if (success) {
            if ([self isRequestSuccessful:resultObject]) {
                if (callback) callback(YES, nil);
            } else {
                if (callback) callback(NO, [self getMessage:resultObject]);
            }
        } else {
            if (callback) callback(NO, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

- (void)requestAmountFromUser:(NSString *)userId amount:(float)amount currencyIso:(NSString *)currencyIso text:(NSString *)text callback:(void (^)(bool success, NSString* message))callback {
    
    if ([self isEmptyOrNil:userId] || [self isEmptyOrNil:currencyIso]) {
        if (callback) callback(NO, @"Attempt to send an empty value to the service");
        return;
    }
    
    text = [self getNonNilValueForString:text];
    NSDictionary *params = @{
                             @"destAcocuntId": userId,
                             @"amount": @(amount),
                             @"currencyIso": currencyIso,
                             @"text": text,
                             };
    [self sendGetJsonRequestWithParameters:params withMethod:@"RequestAmount" callback:^(BOOL success, id resultObject) {
        if (success) {
            if ([self isRequestSuccessful:resultObject]) {
                if (callback) callback(YES, nil);
            } else {
                if (callback) callback(NO, [self getMessage:resultObject]);
            }
        } else {
            if (callback) callback(NO, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

- (void)transferAmountToUser:(NSString *)userId amount:(float)amount currencyIso:(NSString *)currencyIso text:(NSString *)text pinCode:(NSString *)pinCode callback:(void (^)(bool success, NSString* message))callback {
    
    if ([self isEmptyOrNil:userId] || [self isEmptyOrNil:currencyIso] || [self isEmptyOrNil:pinCode]) {
        if (callback) callback(NO, @"Attempt to send an empty value to the service");
        return;
    }
    
    text = [self getNonNilValueForString:text];
    NSDictionary *params = @{
                             @"destAcocuntId": userId,
                             @"amount": @(amount),
                             @"currencyIso": currencyIso,
                             @"pinCode": pinCode,
                             @"text": text,
                             };
    [self sendGetJsonRequestWithParameters:params withMethod:@"TransferAmount" callback:^(BOOL success, id resultObject) {
        if (success) {
            if ([self isRequestSuccessful:resultObject]) {
                if (callback) callback(YES, nil);
            } else {
                if (callback) callback(NO, [self getMessage:resultObject]);
            }
        } else {
            if (callback) callback(NO, ((NSError*)resultObject).localizedDescription);
        }
    }];
    
}

- (void)loadBalanceFromCardWithNumber:(NSString *)cardNumber cardExpirationMonth:(int)expMonth cardExpirationYear:(int)expYear cardCvv:(NSString*)cvv idNumber:(NSString*)idNumber storedPaymentMethodId:(NSInteger)storedPaymentMethodId installments:(int)installments currencyIso:(NSString*)currencyIso amount:(float)amount callback:(void (^)(bool success, NSString* message))callback {
    
    if ([self isEmptyOrNil:cardNumber] || [self isEmptyOrNil:cvv] || [self isEmptyOrNil:idNumber] || [self isEmptyOrNil:currencyIso]) {
        if (callback) callback(NO, @"Attempt to send an empty value to the service");
        return;
    }
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:15];
    [components setMonth:expMonth];
    [components setYear:expYear];
    NSDate *date = [NSCalendar.currentCalendar dateFromComponents:components];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"];
    NSString *expDate = [dateFormatter stringFromDate:date];
    
    NSDictionary *params = @{
                             @"Amount": @(amount),
                             @"CurrencyIso": currencyIso,
                             @"Installments": @(installments),
                             @"StoredPaymentMethodID": @(storedPaymentMethodId),
                             @"CardNumber": cardNumber,
                             @"CardExpDate": expDate,
                             @"Cvv": cvv,
                             @"IdNumber": idNumber,
                             };
    NSDictionary *data = @{ @"data": params };
    [self sendGetJsonRequestWithParameters:data withMethod:@"LoadBalance" callback:^(BOOL success, id resultObject) {
        if (success) {
            /** TO DO:
             explanations
             isSuccess/Message
             parse response */
            if ([self isRequestSuccessful:resultObject]) {
                if (callback) callback(YES, nil);
            } else {
                if (callback) callback(NO, [self getMessage:resultObject]);
            }
        } else {
            if (callback) callback(NO, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

/************************************* REQUESTS SECTION END *************************************/

- (RequestItemOld*)parseRequest:(NSDictionary*)dictionary {
    RequestItemOld *item = [RequestItemOld new];
    item.requestId = [self getObject:@"ID" from:dictionary];
    item.requestDate = [self getReadableDate:[self getObject:@"RequestDate" from:dictionary]];
    item.sourceAccountNumber = [self getObject:@"SourceAccountNumber" from:dictionary];
    item.targetAccountNumber = [self getObject:@"TargetAccountNumber" from:dictionary];
    item.sourceText = [self getObject:@"SourceText" from:dictionary];
    item.targetText = [self getObject:@"TargetText" from:dictionary];
    item.sourceAccountName = [self getObject:@"SourceAccountName" from:dictionary];
    item.targetAccountName = [self getObject:@"TargetAccountName" from:dictionary];
    item.isPush = [[self getObject:@"IsPush" from:dictionary] boolValue];
    item.amount = [self getObject:@"Amount" from:dictionary];
    item.currencyISOCode = [self getObject:@"CurrencyISOCode" from:dictionary];
    item.isApproved = [[self getObject:@"IsApproved" from:dictionary] boolValue];
    item.confirmDate = [self getReadableDate:[self getObject:@"ConfirmDate" from:dictionary]];
    return item;
}

@end