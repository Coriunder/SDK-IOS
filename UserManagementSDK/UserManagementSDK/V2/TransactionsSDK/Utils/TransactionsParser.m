//
//  TransactionsParser.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Parser methods for Transactions services

#import "TransactionsParser.h"

@implementation TransactionsParser

- (Transaction*)parseTransaction:(NSDictionary*)transactionDict {
    Transaction *transaction = [Transaction new];
    [transaction setAmount:[self getDouble:@"Amount" from:transactionDict]];
    [transaction setAuthCode:[self getString:@"AuthCode" from:transactionDict]];
    [transaction setComment:[self getString:@"Comment" from:transactionDict]];
    [transaction setCurrencyIso:[self getString:@"CurrencyIso" from:transactionDict]];
    [transaction setTransactionId:[self getLong:@"ID" from:transactionDict]];
    [transaction setInsertDate:[self getReadableDate:@"InsertDate" from:transactionDict]];
    [transaction setInstallments:[self getInt:@"Installments" from:transactionDict]];
    [transaction setIsManual:[self getBool:@"IsManual" from:transactionDict]];
    [transaction setIsRefunded:[self getBool:@"IsRefunded" from:transactionDict]];
    [transaction setMerchant:[self parseMerchant:[self getDictionary:@"Merchant" from:transactionDict]]];
    
    // Parse payer data
    NSDictionary *payerDataDictionary = [self getDictionary:@"PayerData" from:transactionDict];
    if (payerDataDictionary != nil) {
        [transaction setPayerEmail:[self getString:@"Email" from:payerDataDictionary]];
        [transaction setPayerFullName:[self getString:@"FullName" from:payerDataDictionary]];
        [transaction setPayerPhone:[self getString:@"Phone" from:payerDataDictionary]];
        [transaction setPayerShippingAddress:[self parseAddress:[self getDictionary:@"ShippingAddress" from:payerDataDictionary]]];
    }
    
    // Parse payment data
    NSDictionary *paymentDataDictionary = [self getDictionary:@"PaymentData" from:transactionDict];
    if (paymentDataDictionary != nil) {
        [transaction setPaymentDataBillingAddress:[self parseAddress:[self getDictionary:@"BillingAddress" from:paymentDataDictionary]]];
        [transaction setPaymentDataBin:[self getString:@"Bin" from:paymentDataDictionary]];
        [transaction setPaymentDataBinCountry:[self getString:@"BinCountry" from:paymentDataDictionary]];
        [transaction setPaymentDataExpirationMonth:[self getInt:@"ExpirationMonth" from:paymentDataDictionary]];
        [transaction setPaymentDataExpirationYear:[self getInt:@"ExpirationYear" from:paymentDataDictionary]];
        [transaction setPaymentDataLast4:[self getString:@"Last4" from:paymentDataDictionary]];
        [transaction setPaymentDataType:[self getString:@"Type" from:paymentDataDictionary]];
    }
    
    [transaction setPaymentDisplay:[self getString:@"PaymentDisplay" from:transactionDict]];
    [transaction setPaymentMethodGroupKey:[self getString:@"PaymentMethodGroupKey" from:transactionDict]];
    [transaction setPaymentMethodKey:[self getString:@"PaymentMethodKey" from:transactionDict]];
    [transaction setReceiptLink:[self getString:@"ReceiptLink" from:transactionDict]];
    [transaction setReceiptText:[self getString:@"ReceiptText" from:transactionDict]];
    [transaction setText:[self getString:@"Text" from:transactionDict]];
    
    return transaction;
}

- (NSMutableArray*)parseTransactionLookup:(id)resultObject {
    NSArray *responseArray = [self getArray:@"d" from:resultObject];
    NSMutableArray *result = [NSMutableArray new];
    if (responseArray != nil) {
        for (NSDictionary *transactionDict in responseArray) {
            TransactionLookup *transaction = [TransactionLookup new];
            [transaction setMerchantName:[self getString:@"MerchantName" from:transactionDict]];
            [transaction setMerchantSupportEmail:[self getString:@"MerchantSupportEmail" from:transactionDict]];
            [transaction setMerchantSupportPhone:[self getString:@"MerchantSupportPhone" from:transactionDict]];
            [transaction setMerchantWebSite:[self getString:@"MerchantWebSite" from:transactionDict]];
            [transaction setMethodString:[self getString:@"MethodString" from:transactionDict]];
            [transaction setTransactionDate:[self getReadableDate:@"TransDate" from:transactionDict]];
            [transaction setTransactionID:[self getLong:@"TransID" from:transactionDict]];
            [result addObject:transaction];
        }
    }
    return result;
}

- (NSMutableArray*)parseSearch:(id)resultObject {
    NSArray *responseArray = [self getArray:@"d" from:resultObject];
    NSMutableArray *result = [NSMutableArray new];
    if (responseArray != nil) {
        for (NSDictionary *dict in responseArray) {
            [result addObject:[self parseTransaction:dict]];
        }
    }
    return result;
}

@end
