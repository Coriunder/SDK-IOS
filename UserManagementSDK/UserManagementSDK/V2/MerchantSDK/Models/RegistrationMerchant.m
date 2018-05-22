//
//  RegistrationMerchant.m
//  UserManagementSDK
//
//  Created by Lev T on 23/08/16.
//  Copyright © 2016 Sapdan. All rights reserved.
//

#import "RegistrationMerchant.h"

@implementation RegistrationMerchant

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.address = @"";
        self.anticipatedAverageTransactionAmount = 0;
        self.anticipatedLargestTransactionAmount = 0;
        self.anticipatedMonthlyVolume = 0;
        self.bankAccountNumber = @"";
        self.bankRoutingNumber = @"";
        self.businessDescription = @"";
        self.businessStartDate = [NSDate new];
        self.canceledCheckImage = @"";
        self.city = @"";
        self.dbaName = @"";
        self.email = @"";
        self.fax = @"";
        self.firstName = @"";
        self.industry = 0;
        self.lastName = @"";
        self.legalBusinessName = @"";
        self.legalBusinessNumber = @"";
        self.ownerDob = [NSDate new];
        self.ownerSsn = @"";
        self.percentDelivery0to7 = 0;
        self.percentDelivery15to30 = 0;
        self.percentDelivery8to14 = 0;
        self.percentDeliveryOver30 = 0;
        self.physicalAddress = @"";
        self.physicalCity = @"";
        self.physicalState = @"";
        self.physicalZip = @"";
        self.phone = @"";
        self.state = @"";
        self.stateOfIncorporation = @"";
        self.typeOfBusiness = 0;
        self.url = @"";
        self.zipcode = @"";
    }
    return self;
}

@end