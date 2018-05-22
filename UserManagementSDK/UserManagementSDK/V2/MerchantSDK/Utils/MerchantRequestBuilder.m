//
//  MerchantRequestBuilder.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods designed to prepare
//  NSDictionary to send with requests to Merchant service

#import "MerchantRequestBuilder.h"

@implementation MerchantRequestBuilder

- (NSDictionary*)buildRegisterMerchantJson:(RegistrationMerchant*)merchant {    
    // Parse owner birth date to server applicable format
    if (merchant.ownerDob == nil) merchant.ownerDob = [NSDate new];
    NSString *birthDateString = [NSString stringWithFormat:@"/Date(%0.0f)/",[merchant.ownerDob timeIntervalSince1970]*1000];
    
    // Parse company foundation date to server applicable format
    if (merchant.businessStartDate == nil) merchant.businessStartDate = [NSDate new];
    NSString *companyDateString = [NSString stringWithFormat:@"/Date(%0.0f)/",[merchant.businessStartDate timeIntervalSince1970]*1000];
    
    NSDictionary *data = @{ @"Address": [self getNonNilValueForString:merchant.address],
                            @"AnticipatedAverageTransactionAmount": @(merchant.anticipatedAverageTransactionAmount),
                            @"AnticipatedLargestTransactionAmount": @(merchant.anticipatedLargestTransactionAmount),
                            @"AnticipatedMonthlyVolume": @(merchant.anticipatedMonthlyVolume),
                            @"BankAccountNumber": [self getNonNilValueForString:merchant.bankAccountNumber],
                            @"BankRoutingNumber": [self getNonNilValueForString:merchant.bankRoutingNumber],
                            @"BusinessDescription": [self getNonNilValueForString:merchant.businessDescription],
                            @"BusinessStartDate": [self getNonNilValueForString:companyDateString],
                            @"CanceledCheckImage": [self getNonNilValueForString:merchant.canceledCheckImage],
                            @"City": [self getNonNilValueForString:merchant.city],
                            @"DbaName": [self getNonNilValueForString:merchant.dbaName],
                            @"Email": [self getNonNilValueForString:merchant.email],
                            @"Fax": [self getNonNilValueForString:merchant.fax],
                            @"FirstName": [self getNonNilValueForString:merchant.firstName],
                            @"Industry": @(merchant.industry),
                            @"LastName": [self getNonNilValueForString:merchant.lastName],
                            @"LegalBusinessName": [self getNonNilValueForString:merchant.legalBusinessName],
                            @"LegalBusinessNumber": [self getNonNilValueForString:merchant.legalBusinessNumber],
                            @"OwnerDob": [self getNonNilValueForString:birthDateString],
                            @"OwnerSsn": [self getNonNilValueForString:merchant.ownerSsn],
                            @"PercentDelivery0to7": @(merchant.percentDelivery0to7),
                            @"PercentDelivery15to30": @(merchant.percentDelivery15to30),
                            @"PercentDelivery8to14": @(merchant.percentDelivery8to14),
                            @"PercentDeliveryOver30": @(merchant.percentDeliveryOver30),
                            @"PhisicalAddress": [self getNonNilValueForString:merchant.physicalAddress],
                            @"PhisicalCity": [self getNonNilValueForString:merchant.physicalCity],
                            @"PhisicalState": [self getNonNilValueForString:merchant.physicalState],
                            @"PhisicalZip": [self getNonNilValueForString:merchant.physicalZip],
                            @"Phone": [self getNonNilValueForString:merchant.phone],
                            @"State": [self getNonNilValueForString:merchant.state],
                            @"StateOfIncorporation": [self getNonNilValueForString:merchant.stateOfIncorporation],
                            @"TypeOfBusiness": @(merchant.typeOfBusiness),
                            @"Url": [self getNonNilValueForString:merchant.url],
                            @"Zipcode": [self getNonNilValueForString:merchant.zipcode], };
    return @{ @"RegistrationData": data, };
}

/**
 * Method to get non-nil NSString object
 * @param string NSString which shouldn't be nil
 */
-(NSString*)getNonNilValueForString:(NSString*)string {
    return (string == nil) ? @"" : string;
}

@end
