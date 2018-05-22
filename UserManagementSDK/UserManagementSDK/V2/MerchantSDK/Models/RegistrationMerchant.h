//
//  RegistrationMerchant.h
//  UserManagementSDK
//
//  Created by Lev T on 23/08/16.
//  Copyright © 2016 Sapdan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegistrationMerchant : NSObject

@property (strong, nonatomic) NSString *address;
@property double anticipatedAverageTransactionAmount;
@property double anticipatedLargestTransactionAmount;
@property double anticipatedMonthlyVolume;
@property (strong, nonatomic) NSString *bankAccountNumber;
@property (strong, nonatomic) NSString *bankRoutingNumber;
@property (strong, nonatomic) NSString *businessDescription;
@property (strong, nonatomic) NSDate *businessStartDate;
@property (strong, nonatomic) NSString *canceledCheckImage; //base64Binary
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *dbaName;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *fax;
@property (strong, nonatomic) NSString *firstName;
@property int industry;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *legalBusinessName;
@property (strong, nonatomic) NSString *legalBusinessNumber;
@property (strong, nonatomic) NSDate *ownerDob;
@property (strong, nonatomic) NSString *ownerSsn;
@property int percentDelivery0to7;
@property int percentDelivery15to30;
@property int percentDelivery8to14;
@property int percentDeliveryOver30;
@property (strong, nonatomic) NSString *physicalAddress;
@property (strong, nonatomic) NSString *physicalCity;
@property (strong, nonatomic) NSString *physicalState;
@property (strong, nonatomic) NSString *physicalZip;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *stateOfIncorporation;
@property int typeOfBusiness;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *zipcode;

@end
