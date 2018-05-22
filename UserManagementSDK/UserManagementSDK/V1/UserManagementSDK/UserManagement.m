//
//  UserManagement.m

//
//  Created by v_stepanov on 19.11.14.
//  Copyright (c) 2014 OBL Computer Network. All rights reserved.
//

#import "UserManagement.h"
#import "KeychainItemWrapper.h"
#import "FriendOld.h"
#import "ShipmentAddressOld.h"
#import "PaymentMethodOld.h"
#import "PaymentCardRootGroupOld.h"
#import "PaymentCardSubrootGroupOld.h"
#import "TransactionOld.h"
#import "RelationOld.h"
#import "BillingAddressOld.h"
#import "TransactionMerchantOld.h"

@implementation UserManagement {
    NSTimer *timer;
}

static UserManagement *_instance = nil;

-(id)init {
    self = [super init];
    if (self) {
        timer = nil;
        self.plistName = @"UserManagementSetup";
    }
    return self;
}

+ (UserManagement *)getInstance {
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [UserManagement new];
        }
    }
    return _instance;
}

- (void)sendGetJsonRequestWithParameters:(NSDictionary *)params withMethod:(NSString *)method responseSerializer:(typeSerializer)responseSerializer callback:(void (^)(BOOL success, id resultObject))completion {
    
    [self sendPostRequestWithParameters:params withMethod:method credentialsToken:self.credentialsToken responseSerializer:responseSerializer callback:completion];
}

- (void)sendGetHttpRequestWithParameters:(NSDictionary *)params withMethod:(NSString *)method callback:(void (^)(BOOL success, id resultObject))completion {
    
    [self sendGetRequestWithParameters:params withMethod:method credentialsToken:self.credentialsToken callback:completion];
}

/************************************ PRE-LOGIN SECTION START ************************************/

- (void)registerUserWithName:(NSString*)firstName surname:(NSString*)lastName password:(NSString*)password pinCode:(NSString*)pinCode email:(NSString*)email pushToken:(NSString *)pushToken callback:(void (^)(BOOL success, NSDictionary *response, NSString* message))callback {
    
    if ([self isEmptyOrNil:firstName] || [self isEmptyOrNil:lastName] || [self isEmptyOrNil:pinCode] || [self isEmptyOrNil:email]) {
        if (callback) callback(NO, nil, @"Attempt to send an empty value to the service");
        return;
    }
    
    if (![self validatePassword:password]) {
        if (callback) callback(NO, nil, @"Password should contain at least 9 symbols including 2 chars and 2 numbers");
        return;
    }
    
    NSMutableDictionary *walletRegisterData = [NSMutableDictionary new];
    [walletRegisterData setObject:password forKey:@"Password"];
    [walletRegisterData setObject:pinCode forKey:@"PinCode"];
    [walletRegisterData setObject:[self getAppToken] forKey: @"ApplicationToken"];
    NSDictionary *walletCustomer = @{
                                     @"FirstName": firstName,
                                     @"LastName": lastName,
                                     @"EmailAddress": email,
                                     };
    [walletRegisterData setObject:walletCustomer forKey:@"info"];
    NSMutableDictionary *data = [NSMutableDictionary new];
    [data setObject:walletRegisterData forKey:@"data"];
    
    [self sendGetJsonRequestWithParameters:data withMethod:@"RegisterCustomer" responseSerializer:responseJSON callback:^(BOOL success, id resultObject) {
        
        if (success) {
            if ([self isRequestSuccessful:resultObject]) {
                [self loginAfterSignUp:email password:password pushToken:pushToken callback:callback];
            } else {
                if (callback) callback(NO, nil, [self getMessage:resultObject]);
            }
        } else {
            if (callback) callback(NO, nil, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

-(void)loginAfterSignUp:(NSString*)email password:(NSString*)password pushToken:(NSString *)pushToken callback:(void (^)(BOOL success, NSDictionary *response, NSString* message))callback {
    [self loginWithEmail:email password:password pushToken:pushToken callback:^(BOOL success, NSDictionary *response, NSString* message) {
        if (success) {
            if (callback) callback(YES, response, nil);
        } else {
            if (callback)
                callback(NO, response, [NSString stringWithFormat:@"Signed up successfully. An error occured while logging in: %@",message]);
        }
    }];
}

- (void)checkUserEmail:(NSString *)email callback:(void (^)(BOOL success, NSString *message))callback {
    if ([self isEmptyOrNil:email]) {
        if (callback) callback(NO, @"Attempt to send an empty value to the service");
        return;
    }
    
    NSDictionary *params = @{
                             @"applicationToken":[self getAppToken],
                             @"email":email,
                             };
    [self sendGetJsonRequestWithParameters:params withMethod:@"IsFreeEmailAddress" responseSerializer:responseNONE callback:^(BOOL success, id resultObject) {
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

- (BOOL)isUserLoggedIn {
    return ![self isEmptyOrNil:self.credentialsToken];
}

- (void)loginWithEmail:(NSString *)email password:(NSString *)password pushToken:(NSString *)pushToken callback:(void (^)(BOOL success, NSDictionary *response, NSString *message))callback {
    
    if ([self isEmptyOrNil:email] || [self isEmptyOrNil:password]) {
        if (callback) callback(NO, nil, @"Attempt to send an empty value to the service");
        return;
    }
    
    NSMutableDictionary *loginDict = [[NSMutableDictionary alloc] init];
    [loginDict setObject:email forKey:@"email"];
    [loginDict setObject:password forKey:@"password"];
    
    NSDictionary *optionDict = @{
                                 @"setCookie": [NSNumber numberWithBool:NO],
                                 @"applicationToken": [self getAppToken],
                                 @"appName": @"iPhone Wallet App",
                                 @"deviceId": @"",
                                 @"pushToken":[self getNonNilValueForString:pushToken],
                                 @"excludeDataImages":[NSNumber numberWithBool:YES],
                                 };
    [loginDict setObject:optionDict forKey:@"options"];
    
    [self sendGetJsonRequestWithParameters:loginDict withMethod:@"Login" responseSerializer:responseJSON callback:^(BOOL success, id resultObject) {
        if (success) {
            if ([self isRequestSuccessful:resultObject]) {
                NSDictionary *dict = [self getObject:@"d" from:resultObject];
                if (dict != nil) self.credentialsToken = [self getObject:@"CredentialsToken" from:dict];
                [self startTimerForKeepAliveSession];
                
                [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"LoginEmail"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc]
                                                     initWithIdentifier:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]
                                                     accessGroup:nil];
                [keychainItem setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"] forKey:(id)kSecAttrService];
                [keychainItem setObject:password forKey:(__bridge id)(kSecValueData)];
                
                if (dict != nil) {
                    NSDictionary *response = @{
                                               @"UserId":[self getObject:@"Number" from:dict],
                                               @"LastLogin":[self getReadableDate:[self getObject:@"LastLogin" from:dict]],
                                               @"IsFirstLogin":[self getObject:@"IsFirstLogin" from:dict],
                                               @"VersionUpdateRequired":[self getObject:@"VersionUpdateRequired" from:dict],
                                               };
                    if (callback) callback(YES, response, nil);
                } else {
                    if (callback) callback(YES, [NSDictionary new], nil);
                }
                
            } else {
                if (callback) callback(NO, nil, [self getMessage:resultObject]);
            }
        } else {
            if (callback) callback(NO, nil, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

- (void)tryAutoLoginWithPushToken:(NSString *)pushToken callback:(void (^)(BOOL success, NSDictionary *response, NSString *message))callback {
    
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc]
                                         initWithIdentifier:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]
                                         accessGroup:nil];
    NSString *password = [keychainItem objectForKey:(__bridge id)(kSecValueData)];
    NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginEmail"];
    
    if ((email.length > 0) && password.length > 0) {
        [self loginWithEmail:email password:password pushToken:pushToken callback:^(BOOL success, NSDictionary *response, NSString* message) {
            if (success) {
                if (callback) callback(YES, response, nil);
            } else {
                if (callback) callback(NO, response, message);
            }
        }];
    } else if (callback) callback(NO, [NSDictionary new], @"Stored login data not found");
}

- (void)resetPasswordForEmail:(NSString *)email callback:(void (^)(bool success, NSString *message))callback {
    
    if ([self isEmptyOrNil:email]) {
        if (callback) callback(NO, @"Attempt to send an empty value to the service");
        return;
    }
    
    NSDictionary *params = @{ @"email": email, };
    
    [self sendGetJsonRequestWithParameters:params withMethod:@"ResetPassword" responseSerializer:responseJSON callback:^(BOOL success, id resultObject) {
        if (success) {
            if ([[self getObject:@"d" from:resultObject] boolValue]) {
                if (callback) callback(YES, nil);
            } else {
                if (callback) callback(NO, @"Something went wrong");
            }
        } else {
            if (callback) callback(NO, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

-(void)logOff:(void (^)(bool success))callback {
    [self sendGetJsonRequestWithParameters:nil withMethod:@"LogOff" responseSerializer:responseJSON callback:^(BOOL success, id resultObject) {
        if (success) {
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"LoginEmail"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self stopTimerForKeepAliveSession];
            if (callback) callback(YES);
            
        } else {
            if (callback) callback(NO);
        }
    }];
}

/************************************* PRE-LOGIN SECTION END *************************************/


/********************************** CUSTOMER DATA SECTION START **********************************/

- (void)getCustomerWithCallback:(void (^)(bool success, CustomerOld* customer, NSString* message))callback {
    [self sendGetJsonRequestWithParameters:nil withMethod:@"GetCustomer" responseSerializer:responseJSON callback:^(BOOL success, id resultObject) {
        if (success) {
            if (resultObject != nil) {
                CustomerOld* responseCustomer = [self parseCustomer:resultObject];
                if (callback) callback(YES, responseCustomer, nil);
            } else {
                if (callback) callback(NO, nil, @"Something went wrong");
            }
        } else {
            if (callback) callback(NO, nil, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

- (void)saveCustomerWithFirstName:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email address1:(NSString *)address1 address2:(NSString *)address2 city:(NSString *)city zipCode:(NSString *)zipCode stateIso:(NSString *)stateIso countryIso:(NSString *)countryIso phone:(NSString *)phone profileImage:(UIImage *)profileImage birthDay:(int)birthDay birthMonth:(int)birthMonth birthYear:(int)birthYear personalNumber:(NSString*)personalNumber cellNumber:(NSString*)cellNumber callback:(void (^)(bool success, CustomerOld* customer, NSString* message))callback {
    
    if ([self isEmptyOrNil:firstName] || [self isEmptyOrNil:lastName] || [self isEmptyOrNil:email]) {
        if (callback) callback(NO, nil, @"Attempt to send an empty value to the service. First name, last name and email can't be empty");
        return;
    }
    
    NSCalendar *current = [NSCalendar currentCalendar];
    NSDateComponents *currentComp = [current components:NSCalendarUnitYear fromDate:[NSDate date]];
    if (birthYear < 1900 || birthYear > [currentComp year]) {
        if (callback) callback(NO, nil, @"Attempt to send wrong year");
        return;
    }
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:birthDay];
    [components setMonth:birthMonth];
    [components setYear:birthYear];
    [components setHour:12];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *date = [NSCalendar.currentCalendar dateFromComponents:components];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"];
    NSString *bDate = [dateFormatter stringFromDate:date];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:firstName forKey:@"FirstName"];
    [params setObject:lastName forKey:@"LastName"];
    [params setObject:email forKey:@"EmailAddress"];
    [params setObject:[self getNonNilValueForString:address1] forKey:@"AddressLine1"];
    [params setObject:[self getNonNilValueForString:address2] forKey:@"AddressLine2"];
    [params setObject:[self getNonNilValueForString:city] forKey:@"City"];
    [params setObject:[self getNonNilValueForString:zipCode] forKey:@"PostalCode"];
    [params setObject:[self getNonNilValueForString:countryIso] forKey:@"CountryIso"];
    [params setObject:[self getNonNilValueForString:stateIso] forKey:@"StateIso"];
    [params setObject:[self getNonNilValueForString:phone] forKey:@"PhoneNumber"];
    [params setObject:[self getNonNilValueForString:personalNumber] forKey:@"PersonalNumber"];
    [params setObject:[self getNonNilValueForString:cellNumber] forKey:@"CellNumber"];
    [params setObject:[self getNonNilValueForString:bDate] forKey:@"DateOfBirth"];
    
    if (profileImage) {
        UIImage *image = profileImage;
        NSData *data = UIImagePNGRepresentation(image);
        NSUInteger len = data.length;
        uint8_t *bytes = (uint8_t *)[data bytes];
        NSMutableString *result = [NSMutableString stringWithCapacity:len * 3];
        for (NSUInteger i = 0; i < len; i++) {
            if (i) [result appendString:@","];
            [result appendFormat:@"%d", bytes[i]];
        }
        NSArray *words = [result componentsSeparatedByString:@","];
        NSMutableArray *triples = [NSMutableArray new];
        for (NSUInteger i = 0; i < words.count; i ++) {
            [triples addObject:words[i]];
        }
        [params setObject:triples forKey:@"ProfileImage"];
    }
    NSMutableDictionary *infoDict = [NSMutableDictionary new];
    [infoDict setObject:params forKey:@"info"];
    
    [self sendGetJsonRequestWithParameters:infoDict withMethod:@"SaveCustomer" responseSerializer:responseJSON callback:^(BOOL success, id resultObject) {
        if (success) {
            if ([self isRequestSuccessful:resultObject]) {
                [self getCustomerWithCallback:^(bool success, CustomerOld *customer, NSString *message) {
                    if (success) {
                        if (callback) callback(YES, customer, message);
                    } else {
                        if (callback) callback(YES, nil, @"Profile was saved, but local info wasn't updated. Call getCustomer to force updating local info");
                    }
                }];
            } else {
                if (callback) callback(NO, nil, [self getMessage:resultObject]);
            }
        } else {
            if (callback) callback(NO, nil, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

- (void)setNewPassword:(NSString*)newPassword oldPassword:(NSString*)oldPassword callback:(void (^)(bool success, NSString* message))callback {
    
    if ([self isEmptyOrNil:oldPassword]) {
        if (callback) callback(NO, @"Attempt to send an empty value to the service");
        return;
    }
    
    if (![self validatePassword:newPassword]) {
        if (callback) callback(NO, @"New password should contain at least 9 symbols including 2 chars and 2 numbers");
        return;
    }
    
    NSDictionary *params = @{
                             @"oldPassword": oldPassword,
                             @"newPassword": newPassword,
                             };
    [self sendGetJsonRequestWithParameters:params withMethod:@"UpdatePassword" responseSerializer:responseJSON callback:^(BOOL success, id resultObject) {
        if (success) {
            if ([self isRequestSuccessful:resultObject]) {
                KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc]
                                                     initWithIdentifier:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]
                                                     accessGroup:nil];
                [keychainItem setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"] forKey:(id)kSecAttrService];
                [keychainItem setObject:newPassword forKey:(__bridge id)(kSecValueData)];
                if (callback) callback(YES, nil);
            } else {
                if (callback) callback(NO, [self getMessage:resultObject]);
            }
        } else {
            if (callback) callback(NO, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

- (void)setNewPincode:(NSString *)newPincode password:(NSString *)password callback:(void (^)(bool success, NSString* message))callback {
    
    if ([self isEmptyOrNil:newPincode] || [self isEmptyOrNil:password]) {
        if (callback) callback(NO, @"Attempt to send an empty value to the service");
        return;
    }
    
    NSDictionary *params = @{
                             @"password": password,
                             @"newPincode": newPincode,
                             };
    [self sendGetJsonRequestWithParameters:params withMethod:@"UpdatePincode" responseSerializer:responseJSON callback:^(BOOL success, id resultObject) {
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

- (void)getBillingAddressesWithCallback:(void (^)(bool success, NSMutableArray *array, NSString* message))callback {
    [self sendGetJsonRequestWithParameters:nil withMethod:@"GetBillingAddresses" responseSerializer:responseJSON callback:^(BOOL success, id resultObject) {
        if (success) {
            NSArray *result = [self getObject:@"d" from:resultObject];
            NSMutableArray* addressesArray = [[NSMutableArray alloc] init];
            if (result != nil) {
                for (NSDictionary *addressDict in result) {
                    BillingAddressOld *address = [self parseBillingAddress:addressDict];
                    [addressesArray addObject:address];
                }
                if (callback) callback(YES, addressesArray, nil);
            } else {
                if (callback) callback(YES, addressesArray, nil);
            }
        } else {
            if (callback) callback(NO, nil, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

/*********************************** CUSTOMER DATA SECTION END ***********************************/


/********************************* SHIPPING ADDRESS SECTION START ********************************/

- (void)getShippingAddressWithId:(long)addressId callback:(void (^)(BOOL success, ShipmentAddressOld *address, NSString* message))callback {
    NSDictionary *params = @{ @"addressId": @(addressId), };
    [self sendGetJsonRequestWithParameters:params withMethod:@"GetShippingAddress" responseSerializer:responseJSON callback:^(BOOL success, id resultObject) {
        if (success) {
            NSDictionary *result = [self getObject:@"d" from:resultObject];
            if (result != nil) {
                ShipmentAddressOld *address = [self parseShippingAddress:result];
                if (callback) callback(YES, address, nil);
            } else {
                if (callback) callback(NO, nil, @"Something went wrong or such address doesn't exist");
            }
        } else {
            if (callback) callback(NO, nil, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

- (void)getShippingAddressesWithCallback:(void (^)(BOOL success, NSMutableArray* addressesArray, NSString* message))callback {
    [self sendGetJsonRequestWithParameters:nil withMethod:@"GetShippingAddresses" responseSerializer:responseJSON callback:^(BOOL success, id resultObject) {
        if (success) {
            NSArray *result = [self getObject:@"d" from:resultObject];
            NSMutableArray* addressesArray = [[NSMutableArray alloc] init];
            if (result != nil) {
                for (NSDictionary *addressDict in result) {
                    ShipmentAddressOld *address = [self parseShippingAddress:addressDict];
                    [addressesArray addObject:address];
                }
                if (callback) callback(YES, addressesArray, nil);
            } else {
                if (callback) callback(YES, addressesArray, nil);
            }
        } else {
            if (callback) callback(NO, nil, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

- (void)saveShippingAddressWithTitle:(NSString *)title address1:(NSString *)address1 address2:(NSString *)address2 city:(NSString *)city countryIso:(NSString *)countryIso stateIso:(NSString *)stateIso zipCode:(NSString *)zipCode comment:(NSString *)comment addressId:(NSString *)addressId isDefault:(BOOL)isDefault callback:(void (^)(bool success, NSString* message))callback {
    
    NSMutableDictionary *params = [self createAddressDictionaryWithAddressTitle:title address1:address1 address2:address2 city:city countryIso:countryIso stateIso:stateIso zipCode:zipCode comment:comment addressId:addressId isDefault:isDefault];
    NSMutableDictionary *addressDict = [NSMutableDictionary new];
    [addressDict setObject:params forKey:@"address"];
    
    [self sendGetJsonRequestWithParameters:addressDict withMethod:@"SaveShippingAddress" responseSerializer:responseJSON callback:^(BOOL success, id resultObject) {
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

- (void)saveShippingAddresses:(NSArray*)shippingAddresses callback:(void (^)(bool success, NSString* message))callback {
    
    if (shippingAddresses == nil || (shippingAddresses != nil && shippingAddresses.count == 0)) {
        if (callback) callback(NO, @"Attempt to send an empty value to the service");
    }
    
    NSMutableArray *addressesArray = [[NSMutableArray alloc]init];
    for (ShipmentAddressOld *address in shippingAddresses) {
        NSMutableDictionary *params = [self createAddressDictionaryWithAddressTitle:address.title address1:address.address1 address2:address.address2 city:address.city countryIso:address.countryIso stateIso:address.stateIso zipCode:address.postalCode comment:address.comment addressId:address.addressId isDefault:address.isDefault];
        [addressesArray addObject:params];
    }
    
    NSMutableDictionary *addressDict = [NSMutableDictionary new];
    [addressDict setObject:addressesArray forKey:@"data"];
    
    [self sendGetJsonRequestWithParameters:addressDict withMethod:@"SaveShippingAddresses" responseSerializer:responseJSON callback:^(BOOL success, id resultObject) {
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

- (void)deleteShippingAddressWithId:(NSString *)addressId callback:(void (^)(bool success, NSString* message))callback {
    if ([self isEmptyOrNil:addressId]) {
        if (callback) callback(NO, @"Attempt to send an empty value to the service");
        return;
    }
    
    NSDictionary *params = @{ @"addressId":addressId, };
    
    [self sendGetJsonRequestWithParameters:params withMethod:@"DeleteShippingAddress" responseSerializer:responseJSON callback:^(BOOL success, id resultObject) {
        if (success) {
            if ([[self getObject:@"d" from:resultObject] boolValue]) {
                if (callback) callback(YES, nil);
            } else {
                if (callback) callback(NO, @"Something went wrong");
            }
        } else {
            if (callback) callback(NO, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

/********************************* SHIPPING ADDRESS SECTION END **********************************/


/********************************* PAYMENT METHODS SECTION START *********************************/

- (void)getPaymentMethodWithId:(long)cardId callback:(void (^)(BOOL success, PaymentMethodOld *paymentMethod, NSString* message))callback {
    NSDictionary *params = @{ @"pmid": @(cardId), };
    [self sendGetJsonRequestWithParameters:params withMethod:@"GetStoredPaymentMethod" responseSerializer:responseJSON callback:^(BOOL success, id resultObject) {
        if (success) {
            NSDictionary *result = [self getObject:@"d" from:resultObject];
            if (result != nil) {
                PaymentMethodOld *paymentMethod = [self parsePaymentMethod:result];
                if (callback) callback(YES, paymentMethod, nil);
            } else {
                if (callback) callback(NO, nil, @"Something went wrong or such payment method doesn't exist");
            }
        } else {
            if (callback) callback(NO, nil, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

- (void)getPaymentMethodsWithCallback:(void (^)(BOOL success, NSMutableArray* paymentMethodsArray, NSString* message))callback {
    [self sendGetJsonRequestWithParameters:nil withMethod:@"GetStoredPaymentMethods" responseSerializer:responseJSON callback:^(BOOL success, id resultObject) {
        if (success) {
            NSArray *result = [self getObject:@"d" from:resultObject];
            NSMutableArray* paymentArray = [[NSMutableArray alloc] init];
            if (result != nil) {
                for (NSDictionary *paymentDict in result) {
                    PaymentMethodOld *paymentMethod = [self parsePaymentMethod:paymentDict];
                    [paymentArray addObject:paymentMethod];
                }
                if (callback) callback(YES, paymentArray, nil);
            } else {
                if (callback) callback(YES, paymentArray, nil);
            }
        } else {
            if (callback) callback(NO, nil, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

- (void)addNewPaymentMethodWithCardNumber:(NSString *)cardNumber accountValue2:(NSString*)accountValue2 title:(NSString*)title expMonth:(NSInteger)expMonth expYear:(NSInteger)expYear paymentMethodKey:(NSString *)paymentMethodKey paymentMethodGroupKey:(NSString *)paymentMethodGroupKey iconUrl:(NSString*)iconUrl display:(NSString*)display ownerName:(NSString *)ownerName isDefault:(BOOL)isDefault usesDefaultAddress:(BOOL)usesDefaultAddress address1:(NSString *)address1 address2:(NSString *)address2 city:(NSString *)city countryIso:(NSString *)countryIso stateIso:(NSString *)stateIso zipCode:(NSString *)zipCode callback:(void (^)(BOOL success, NSString* message))callback {
    
    if ([self isEmptyOrNil:cardNumber] || [self isEmptyOrNil:paymentMethodKey] || [self isEmptyOrNil:paymentMethodGroupKey]) {
        if (callback) callback(NO, @"Attempt to send an empty value to the service");
        return;
    }
    
    NSCalendar *current = [NSCalendar currentCalendar];
    NSDateComponents *currentComp = [current components:NSCalendarUnitYear fromDate:[NSDate date]];
    if (expYear < [currentComp year]) {
        if (callback) callback(NO, @"Card has already expired. Check the expiry year");
        return;
    }
    
    NSMutableDictionary *mainDict = [self createCardDictionaryWithCardNumber:cardNumber accountValue2:accountValue2 cardId:nil title:title expMonth:expMonth expYear:expYear paymentMethodKey:paymentMethodKey paymentMethodGroupKey:paymentMethodGroupKey iconUrl:iconUrl display:display ownerName:ownerName isDefault:isDefault usesDefaultAddress:usesDefaultAddress address1:address1 address2:address2 city:city countryIso:countryIso stateIso:stateIso zipCode:zipCode];
    NSMutableDictionary *methodDataDict = [NSMutableDictionary new];
    [methodDataDict setObject:mainDict forKey:@"methodData"];
    
    [self sendGetJsonRequestWithParameters:methodDataDict withMethod:@"StorePaymentMethod" responseSerializer:responseJSON callback:^(BOOL success, id resultObject) {
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

- (void)updatePaymentMethodWithId:(NSString *)cardId accountValue2:(NSString*)accountValue2 title:(NSString*)title expMonth:(NSInteger)expMonth expYear:(NSInteger)expYear paymentMethodKey:(NSString *)paymentMethodKey paymentMethodGroupKey:(NSString *)paymentMethodGroupKey iconUrl:(NSString*)iconUrl display:(NSString*)display ownerName:(NSString *)ownerName isDefault:(BOOL)isDefault usesDefaultAddress:(BOOL)usesDefaultAddress address1:(NSString *)address1 address2:(NSString *)address2 city:(NSString *)city countryIso:(NSString *)countryIso stateIso:(NSString *)stateIso zipCode:(NSString *)zipCode callback:(void (^)(BOOL success, NSString* message))callback {
    
    if ([self isEmptyOrNil:cardId] || [self isEmptyOrNil:paymentMethodKey] || [self isEmptyOrNil:paymentMethodGroupKey]) {
        if (callback) callback(NO, @"Attempt to send an empty value to the service");
        return;
    }
    
    NSCalendar *current = [NSCalendar currentCalendar];
    NSDateComponents *currentComp = [current components:NSCalendarUnitYear fromDate:[NSDate date]];
    if (expYear < [currentComp year]) {
        if (callback) callback(NO, @"Card has already expired. Check the expiry year");
        return;
    }
    
    NSMutableDictionary *mainDict = [self createCardDictionaryWithCardNumber:nil accountValue2:accountValue2 cardId:cardId title:title expMonth:expMonth expYear:expYear paymentMethodKey:paymentMethodKey paymentMethodGroupKey:paymentMethodGroupKey iconUrl:iconUrl display:display ownerName:ownerName isDefault:isDefault usesDefaultAddress:usesDefaultAddress address1:address1 address2:address2 city:city countryIso:countryIso stateIso:stateIso zipCode:zipCode];
    NSMutableDictionary *methodDataDict = [NSMutableDictionary new];
    [methodDataDict setObject:mainDict forKey:@"methodData"];
    
    [self sendGetJsonRequestWithParameters:methodDataDict withMethod:@"StorePaymentMethod" responseSerializer:responseJSON callback:^(BOOL success, id resultObject) {
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

- (void)savePaymentMethods:(NSArray*)paymentMethods callback:(void (^)(bool success, NSString* message))callback {
    
    if (paymentMethods == nil || (paymentMethods != nil && paymentMethods.count == 0)) {
        if (callback) callback(NO, @"Attempt to send an empty value to the service");
    }
    
    NSMutableArray *cardsArray = [[NSMutableArray alloc]init];
    for (PaymentMethodOld *card in paymentMethods) {
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy"];
        NSInteger expYear = [[formatter stringFromDate:card.expirationDate] integerValue];
        [formatter setDateFormat:@"MM"];
        NSInteger expMonth = [[formatter stringFromDate:card.expirationDate] integerValue];
        
        NSMutableDictionary *params = [self createCardDictionaryWithCardNumber:card.cardNumber accountValue2:card.accountValue2 cardId:card.paymentMethodId title:card.title expMonth:expMonth expYear:expYear paymentMethodKey:card.paymentMethodKey paymentMethodGroupKey:card.paymentMethodGroupKey iconUrl:card.iconURL display:card.displayName ownerName:card.ownerName isDefault:card.isDefault usesDefaultAddress:card.usesBillingAddress address1:card.address.address1 address2:card.address.address2 city:card.address.city countryIso:card.address.countryIso stateIso:card.address.stateIso zipCode:card.address.zipcode];
        [cardsArray addObject:params];
    }
    NSMutableDictionary *cardsDict = [NSMutableDictionary new];
    [cardsDict setObject:cardsArray forKey:@"data"];
    
    [self sendGetJsonRequestWithParameters:cardsDict withMethod:@"StorePaymentMethods" responseSerializer:responseJSON callback:^(BOOL success, id resultObject) {
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

- (void)deletePaymentMethodWithId:(long)cardId callback:(void (^)(bool success, NSString* message))callback {
    NSDictionary *params = @{ @"pmid": @(cardId), };
    [self sendGetJsonRequestWithParameters:params withMethod:@"DeleteStoredPaymentMethod" responseSerializer:responseJSON callback:^(BOOL success, id resultObject) {
        if (success) {
            if ([[self getObject:@"d" from:resultObject] boolValue]) {
                if (callback) callback(YES, nil);
            } else {
                if (callback) callback(NO, @"Something went wrong");
            }
        } else {
            if (callback) callback(NO, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

/********************************** PAYMENT METHODS SECTION END **********************************/


/************************************* FRIENDS SECTION START ************************************/

- (void)getFriendListWithCallback:(void (^)(bool success, NSMutableArray* friendsArray, NSString* message))callback {
    [self getFriendWithId:[NSNull null] callback:callback];
}

- (void)getFriendWithId:(id)friendId callback:(void (^)(bool success, NSMutableArray* friendsArray, NSString* message))callback {
    if (friendId == nil) {
        if (callback) callback(NO, nil, @"Attempt to send an empty value to the service");
        return;
    }
    
    NSDictionary *params = @{ @"destWalletId": friendId, };
    [self sendGetJsonRequestWithParameters:params withMethod:@"GetFriends" responseSerializer:responseJSON callback:^(BOOL success, id resultObject) {
        if (success) {
            if ([self isRequestSuccessful:resultObject]) {
                NSMutableArray* friendsArray = [self parseFriendsResponse:resultObject];
                if (callback) callback(YES, friendsArray, nil);
            } else {
                if (callback) callback(NO, nil, [self getMessage:resultObject]);
            }
        } else {
            if (callback) callback(NO, nil, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

- (void)findFriendByIdOrName:(NSString *)nameOrId page:(int)page pageSize:(int)pageSize callback:(void (^)(bool success, NSMutableArray* friendsArray, NSString* message))callback {
    
    if (nameOrId == nil) {
        if (callback) callback(NO, nil, @"Attempt to send an empty value to the service");
        return;
    }
    
    NSDictionary *params = @{
                             @"searchTerm": nameOrId,
                             @"page": @(page),
                             @"pageSize": @(pageSize),
                             };
    [self sendGetJsonRequestWithParameters:params withMethod:@"FindFriend" responseSerializer:responseJSON callback:^(BOOL success, id resultObject) {
        if (success) {
            if ([self isRequestSuccessful:resultObject]) {
                NSMutableArray *resultArray = [self parseFriendsResponse:resultObject];
                if (callback) callback(YES, resultArray, nil);
            } else {
                if (callback) callback(NO, nil, [self getMessage:resultObject]);
            }
        } else {
            if (callback) callback(NO, nil, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

- (void)removeFriendWithId:(NSString *)friendId callback:(void (^)(bool success, NSString* message))callback {
    if (friendId == nil) {
        if (callback) callback(NO, @"Attempt to send an empty value to the service");
        return;
    }
    
    NSDictionary *params = @{ @"destWalletId": friendId, };
    [self sendGetJsonRequestWithParameters:params withMethod:@"RemoveFriend" responseSerializer:responseJSON callback:^(BOOL success, id resultObject) {
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

- (void)setFriendRelation:(int)relation withFriend:(NSString*)friendId callback:(void (^)(bool success, NSString* message))callback {
    if (friendId == nil) {
        if (callback) callback(NO, @"Attempt to send an empty value to the service");
        return;
    }
    
    NSDictionary *params = @{
                             @"destWalletId": friendId,
                             @"relationTypeKey": @(relation),
                             };
    [self sendGetJsonRequestWithParameters:params withMethod:@"SetFriendRelation" responseSerializer:responseJSON callback:^(BOOL success, id resultObject) {
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

/************************************** FRIENDS SECTION END **************************************/


/********************************* FRIEND REQUESTS SECTION START *********************************/

- (void)sendFriendRequestToUserWithID:(NSString *)friendId callback:(void (^)(bool success, NSString* message))callback {
    if (friendId == nil) {
        if (callback) callback(NO, @"Attempt to send an empty value to the service");
        return;
    }
    
    NSDictionary *params = @{
                             @"destWalletId": friendId,
                             //@"notCreate": [NSNumber numberWithBool:NO],
                             };
    [self sendGetJsonRequestWithParameters:params withMethod:@"FriendRequest" responseSerializer:responseJSON callback:^(BOOL success, id resultObject) {
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

- (void)getFriendRequestsWithCallback:(void (^)(bool success, NSMutableArray* friendsArray, NSString* message))callback {
    NSDictionary *params = @{ @"destWalletId": [NSNull null], };
    [self sendGetJsonRequestWithParameters:params withMethod:@"GetFriendRequests" responseSerializer:responseJSON callback:^(BOOL success, id resultObject) {
        if (success) {
            if ([self isRequestSuccessful:resultObject]) {
                NSMutableArray* requestsArray = [self parseFriendsResponse:resultObject];
                if (callback) callback(YES, requestsArray, nil);
            } else {
                if (callback) callback(NO, nil, [self getMessage:resultObject]);
            }
        } else {
            if (callback) callback(NO, nil, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

- (void)replyFriendRequestToFriendWithID:(NSString *)friendId approve:(BOOL)approve callback:(void (^)(bool success, NSString* message))callback {
    if (friendId == nil) {
        if (callback) callback(NO, @"Attempt to send an empty value to the service");
        return;
    }
    NSDictionary *params = @{
                             @"destWalletId": friendId,
                             @"approve": [NSNumber numberWithBool:approve],
                             };
    [self sendGetJsonRequestWithParameters:params withMethod:@"ReplyFriendRequest" responseSerializer:responseJSON callback:^(BOOL success, id resultObject) {
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

/********************************** FRIEND REQUESTS SECTION END **********************************/


/*********************************** TRANSACTIONS SECTION START **********************************/

- (void)processCartWithCookie:(NSString*)cartCookie merchantNumber:(NSString*)merchantNumber totalPrice:(float)totalPrice cartCurrencyIso:(NSString*)cartCurrencyIso pin:(NSString*)pin paymentMethodId:(NSString*)paymentMethodId addressId:(NSString*)addressId callback:(void (^)(bool success, NSString* message))callback {
    
    if ([self isEmptyOrNil:pin] || [self isEmptyOrNil:paymentMethodId] || [self isEmptyOrNil:addressId] ||
        [self isEmptyOrNil:merchantNumber] || [self isEmptyOrNil:cartCurrencyIso] ||
        [self isEmptyOrNil:cartCookie]) {
        if (callback) callback(NO, @"Attempt to send an empty value to the service");
        return;
    }
    
    NSDictionary *data = @{
                           @"PinCode": pin,
                           @"StoredPaymentMethodId": @([paymentMethodId intValue]),
                           @"ShippingAddressId": @([addressId intValue]),
                           @"MerchantNumber": merchantNumber,
                           @"Amount": @(totalPrice),
                           @"CurrencyIso": cartCurrencyIso,
                           @"ShopCartCookie": cartCookie,
                           };
    NSDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:data forKey:@"data"];
    
    [self sendGetJsonRequestWithParameters:params withMethod:@"ProcessTransaction" responseSerializer:responseJSON callback:^(BOOL success, id resultObject) {
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

- (void)getTransactionWithId:(NSString*)transactionId callback:(void (^)(BOOL success, TransactionOld *transaction, NSString* message))callback {
    
    if ([self isEmptyOrNil:transactionId]) {
        if (callback) callback(NO, nil, @"Attempt to send an empty value to the service");
        return;
    }
    
    NSDictionary *params = @{
                             @"transactionId": @([transactionId integerValue]),
                             };
    [self sendGetJsonRequestWithParameters:params withMethod:@"GetTransaction" responseSerializer:responseJSON callback:^(BOOL success, id resultObject) {
        if (success) {
            NSDictionary *result = [self getObject:@"d" from:resultObject];
            if (result != nil) {
                TransactionOld *transaction = [self parseTransaction:result];
                if (callback) callback(YES, transaction, nil);
            } else {
                if (callback) callback(NO, nil, @"Something went wrong");
            }
        } else {
            if (callback) callback(NO, nil, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

- (void)getTransactionsOnPage:(int)page pageSize:(int)pageSize callback:(void (^)(BOOL success, NSMutableArray *transactions, NSString* message))callback {
    NSDictionary *params = @{
                             @"page": @(page),
                             @"pageSize": @(pageSize),
                             };
    [self sendGetJsonRequestWithParameters:params withMethod:@"GetTransactions" responseSerializer:responseJSON callback:^(BOOL success, id resultObject) {
        if (success) {
            NSArray *result = [self getObject:@"d" from:resultObject];
            NSMutableArray *array = [[NSMutableArray alloc]init];
            if (result != nil) {
                for (NSDictionary *transactionDict in result) {
                    TransactionOld *transaction = [self parseTransaction:transactionDict];
                    [array addObject:transaction];
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

/************************************ TRANSACTIONS SECTION END ***********************************/


/********************************** COMMON REQUESTS SECTION START ********************************/

- (void)getPaymentAndRelationListsWithCallback:(void (^)(BOOL success, NSMutableArray *paymentGroups, NSMutableArray *relations, NSString* message))callback {
    [self sendGetJsonRequestWithParameters:nil withMethod:@"GetCustomerLists" responseSerializer:responseJSON callback:^(BOOL success, id resultObject) {
        if (success) {
            NSDictionary *result = [self getObject:@"d" from:resultObject];
            if (result != nil) {
                NSArray *rootGroupResult = [self getObject:@"PaymentMethodGroups" from:result];
                NSMutableArray *subrootGroupResult = [self getObject:@"PaymentMethods" from:result];
                if (rootGroupResult == nil) rootGroupResult = [NSArray new];
                if (subrootGroupResult == nil) subrootGroupResult = [NSMutableArray new];
                
                NSMutableArray *paymentGroups = [[NSMutableArray alloc] init];
                
                //Storing all subroots by roots
                NSMutableDictionary *roots = [NSMutableDictionary new];
                for (NSDictionary *subgroup in subrootGroupResult) {
                    NSString *key = [self getNonNilValueForString:[self getObject:@"GroupKey" from:subgroup]];
                    
                    PaymentCardRootGroupOld *rootModel = [roots objectForKey:key];
                    if (rootModel == nil) {
                        rootModel = [PaymentCardRootGroupOld new];
                        rootModel.icon = nil;
                        rootModel.key = key;
                        rootModel.name = [NSString stringWithFormat:@"Group %@",key];
                        rootModel.subGroups = [NSMutableArray new];
                        [roots setObject:rootModel forKey:key];
                    }
                    
                    PaymentCardSubrootGroupOld *subrootModel = [PaymentCardSubrootGroupOld new];
                    subrootModel.key = [self getObject:@"Key" from:subgroup];
                    subrootModel.name = [self getObject:@"Name" from:subgroup];
                    subrootModel.icon = [self getObject:@"Icon" from:subgroup];
                    subrootModel.groupKey = [self getObject:@"GroupKey" from:subgroup];
                    subrootModel.value1Caption = [self getObject:@"Value1Caption" from:subgroup];
                    subrootModel.value1ValidationRegex = [self getObject:@"Value1ValidationRegex" from:subgroup];
                    subrootModel.value2Caption = [self getObject:@"Value2Caption" from:subgroup];
                    subrootModel.value2ValidationRegex = [self getObject:@"Value2ValidationRegex" from:subgroup];
                    subrootModel.hasExpirationDate = [self getObject:@"HasExpirationDate" from:subgroup];
                    [rootModel.subGroups addObject:subrootModel];
                }
                
                //Storing root data
                NSMutableDictionary *rootsData = [NSMutableDictionary new];
                for (NSDictionary *group in rootGroupResult) {
                    NSString *key = [self getNonNilValueForString:[self getObject:@"Key" from:group]];
                    
                    PaymentCardRootGroupOld *rootModel = [PaymentCardRootGroupOld new];
                    rootModel.icon = [self getObject:@"Icon" from:group];
                    rootModel.key = key;
                    rootModel.name = [self getObject:@"Name" from:group];
                    [rootsData setObject:rootModel forKey:key];
                }
                
                //Setting real root data to roots which hold subroots
                NSArray *allKeys =[roots allKeys];
                for (NSString *key in allKeys) {
                    PaymentCardRootGroupOld *rootModel = [rootsData objectForKey:key];
                    PaymentCardRootGroupOld *savedRoot = [roots objectForKey:key];
                    if (rootModel != nil) {
                        savedRoot.icon = rootModel.icon;
                        savedRoot.key = rootModel.key;
                        savedRoot.name = rootModel.name;
                    }
                    [paymentGroups addObject:savedRoot];
                }
                
                //Parse relations
                NSArray *relationsResult = [self getObject:@"RelationTypes" from:result];
                if (relationsResult == nil) relationsResult = [NSArray new];
                NSMutableArray* relations = [[NSMutableArray alloc] init];
                for (NSDictionary *relationDict in relationsResult) {
                    RelationOld *relation = [RelationOld new];
                    relation.key = [self getObject:@"Key" from:relationDict];
                    relation.name = [self getObject:@"Name" from:relationDict];
                    relation.icon = [self getObject:@"Icon" from:relationDict];
                    [relations addObject:relation];
                }
                
                if (callback) callback(YES, paymentGroups, relations, nil);
            } else {
                if (callback) callback(NO, nil, nil, @"Something went wrong");
            }
        } else {
            if (callback) callback(NO, nil, nil, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

- (void)getImageForUserWithId:(id)userId callback:(void (^)(bool success, UIImage* image, NSString* message))callback {
    if ([self isEmptyOrNil:userId]) {
        if (callback) callback(NO, nil, @"Attempt to send an empty value to the service");
        return;
    }
    
    NSDictionary *params = @{
                             @"walletId": userId,
                             @"asRaw": @"true",
                             };
    
    [self sendGetHttpRequestWithParameters:params withMethod:@"GetImage" callback:^(BOOL success, id resultObject) {
        if (success) {
            if (callback) callback(YES, [UIImage imageWithData:resultObject], nil);
        } else {
            if (callback) callback(NO, nil, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

- (NSString*)getImageUrl:(NSString*)userId {
    return [NSString stringWithFormat:@"%@GetImage?walletId=%@&asRaw=true", [self getServiceUrl], userId];
}

- (void)getCountriesAndStatesWithCallback:(void (^)(BOOL success, NSMutableDictionary *resultDictionary, NSString* message))callback {
    [self sendGetJsonRequestWithParameters:nil withMethod:@"GetLists" responseSerializer:responseJSON callback:^(BOOL success, id resultObject) {
        if (success) {
            NSMutableDictionary *resultDictionary = [[NSMutableDictionary alloc] init];
            [resultDictionary setObject:[self getObject:@"Countries" from:[self getObject:@"d" from:resultObject]] forKey:@"Countries"];
            [resultDictionary setObject:[self getObject:@"UsaStates" from:[self getObject:@"d" from:resultObject]] forKey:@"UsaStates"];
            [resultDictionary setObject:[self getObject:@"CanadaStates" from:[self getObject:@"d" from:resultObject]] forKey:@"CanadaStates"];
            //Languages
            if (callback) callback(YES, resultDictionary, nil);
        } else {
            if (callback) callback(NO, nil, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

/*********************************** COMMON REQUESTS SECTION END *********************************/


/************************************ KEEP ALIVE SECTION START ***********************************/

- (void)keepAliveSession:(void (^)(bool success, id resultObject))callback {
    [self sendGetJsonRequestWithParameters:nil withMethod:@"KeepAlive" responseSerializer:responseJSON callback:^(BOOL success, id resultObject) {
        if (success) {
            if (callback) callback(YES, resultObject);
        } else {
            if (callback) callback(NO, resultObject);
        }
    }];
}

- (void)checkAliveSession {
    [self keepAliveSession:^(bool success, id resultObject) {
        if (success) {
            if ([resultObject objectForKey:@"d"]) {
                //NSLog(@"Keep Alive true");
            } else {
                //NSLog(@"Keep Alive false");
                [self stopTimerForKeepAliveSession];
            }
        } else {
            //NSLog(@"keepAliveSession get error");
            [self stopTimerForKeepAliveSession];
        }
    }];
}

- (void)startTimerForKeepAliveSession {
    timer = [NSTimer scheduledTimerWithTimeInterval:800.0 target:self selector:@selector(checkAliveSession) userInfo:nil repeats:YES];
}

- (void)stopTimerForKeepAliveSession {
    if ([timer isValid]) [timer invalidate];
    
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc]
                                         initWithIdentifier:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]
                                         accessGroup:nil];
    [keychainItem resetKeychainItem];
    self.credentialsToken = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sessionIsInvalid" object:nil];
}

/************************************* KEEP ALIVE SECTION END ************************************/

- (ShipmentAddressOld*)parseShippingAddress:(NSDictionary*)addressDict {
    ShipmentAddressOld *address = [ShipmentAddressOld new];
    address.addressId = [self getObject:@"ID" from:addressDict];
    address.title = [self getObject:@"Title" from:addressDict];
    address.address1 = [self getObject:@"AddressLine1" from:addressDict];
    address.address2 = [self getObject:@"AddressLine2" from:addressDict];
    address.city = [self getObject:@"City" from:addressDict];
    address.postalCode = [self getObject:@"PostalCode" from:addressDict];
    address.stateIso = [self getObject:@"StateIso" from:addressDict];
    address.countryIso = [self getObject:@"CountryIso" from:addressDict];
    address.comment = [self getObject:@"Comment" from:addressDict];
    address.isDefault = [[self getObject:@"IsDefault" from:addressDict] boolValue];
    return address;
}

- (BillingAddressOld*)parseBillingAddress:(NSDictionary*)addressDict {
    BillingAddressOld *address = [BillingAddressOld new];
    address.address1 = [self getObject:@"AddressLine1" from:addressDict];
    address.address2 = [self getObject:@"AddressLine2" from:addressDict];
    address.city = [self getObject:@"City" from:addressDict];
    address.zipcode = [self getObject:@"PostalCode" from:addressDict];
    address.stateIso = [self getObject:@"StateIso" from:addressDict];
    address.countryIso = [self getObject:@"CountryIso" from:addressDict];
    return address;
}

- (TransactionMerchantOld*)parseMerchant:(NSDictionary*)merchantDict {
    TransactionMerchantOld *merchant = [TransactionMerchantOld new];
    merchant.number = [self getObject:@"Number" from:merchantDict];
    merchant.name = [self getObject:@"Name" from:merchantDict];
    merchant.website = [self getObject:@"WebsiteUrl" from:merchantDict];
    merchant.countryIso = [self getObject:@"CountryIso" from:merchantDict];
    merchant.address1 = [self getObject:@"AddressLine1" from:merchantDict];
    merchant.city = [self getObject:@"City" from:merchantDict];
    merchant.phone = [self getObject:@"PhoneNumber" from:merchantDict];
    merchant.email = [self getObject:@"Email" from:merchantDict];
    merchant.zipCode = [self getObject:@"PostalCode" from:merchantDict];
    merchant.address2 = [self getObject:@"AddressLine2" from:merchantDict];
    merchant.stateIso = [self getObject:@"StateIso" from:merchantDict];
    merchant.logoUrl = [self getObject:@"LogoUrl" from:merchantDict];
    return merchant;
}

- (PaymentMethodOld*)parsePaymentMethod:(NSDictionary*)paymentDict {
    PaymentMethodOld *paymentMethod = [PaymentMethodOld new];
    paymentMethod.paymentMethodId = [self getObject:@"ID" from:paymentDict];
    paymentMethod.title = [self getObject:@"Title" from:paymentDict];
    paymentMethod.displayName = [self getObject:@"Display" from:paymentDict];
    paymentMethod.expirationDate = [self getReadableDate:[self getObject:@"ExpirationDate" from:paymentDict]];
    paymentMethod.iconURL = [self getObject:@"Icon" from:paymentDict];
    paymentMethod.isDefault = [[self getObject:@"IsDefault" from:paymentDict] boolValue];
    paymentMethod.ownerName = [self getObject:@"OwnerName" from:paymentDict];
    paymentMethod.paymentMethodGroupKey = [self getObject:@"PaymentMethodGroupKey" from:paymentDict];
    paymentMethod.paymentMethodKey = [self getObject:@"PaymentMethodKey" from:paymentDict];
    paymentMethod.last4Digits = [self getObject:@"Last4Digits" from:paymentDict];
    paymentMethod.issuerCountryIsoCode = [self getObject:@"IssuerCountryIsoCode" from:paymentDict];
    paymentMethod.cardNumber = [self getObject:@"AccountValue1" from:paymentDict];
    paymentMethod.accountValue2 = [self getObject:@"AccountValue2" from:paymentDict];
    
    NSDictionary *addressDict = [self getObject:@"BillingAddress" from:paymentDict];
    if (addressDict != nil) {
        paymentMethod.usesBillingAddress = NO;
        paymentMethod.address = [self parseBillingAddress:addressDict];
    } else {
        paymentMethod.usesBillingAddress = YES;
    }
    return paymentMethod;
}

- (CustomerOld*)parseCustomer:(id)resultObject {
    CustomerOld *customer = [CustomerOld new];
    NSDictionary *dict = [self getObject:@"d" from:resultObject];
    customer.firstName = [self getObject:@"FirstName" from:dict];
    customer.lastName = [self getObject:@"LastName" from:dict];
    customer.phone = [self getObject:@"PhoneNumber" from:dict];
    customer.email = [self getObject:@"EmailAddress" from:dict];
    customer.customerNumber = [self getObject:@"CustomerNumber" from:dict];
    customer.address1 = [self getObject:@"AddressLine1" from:dict];
    customer.address2 = [self getObject:@"AddressLine2" from:dict];
    customer.city = [self getObject:@"City" from:dict];
    customer.zipCode = [self getObject:@"PostalCode" from:dict];
    customer.stateIso = [self getObject:@"StateIso" from:dict];
    customer.countryIso = [self getObject:@"CountryIso" from:dict];
    customer.cellNumber = [self getObject:@"CellNumber" from:dict];
    customer.dateOfBirth = [self getReadableDate:[self getObject:@"DateOfBirth" from:dict]];
    customer.personalNumber = [self getObject:@"PersonalNumber" from:dict];
    customer.profileImageSize = [self getObject:@"ProfileImageSize" from:dict];
    customer.registrationDate = [self getReadableDate:[self getObject:@"RegistrationDate" from:dict]];
    return customer;
}

- (NSMutableArray*)parseFriendsResponse:(id)resultObject {
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (NSDictionary *friendDict in [self getObject:@"Items" from:[self getObject:@"d" from:resultObject]]) {
        FriendOld *friend = [FriendOld new];
        friend.fullName = [self getObject:@"FullName" from:friendDict];
        friend.userId = [self getObject:@"DestWalletId" from:friendDict];
        friend.relationType = [self getObject:@"RelationType" from:friendDict];
        [array addObject:friend];
    }
    return array;
}

- (TransactionOld*)parseTransaction:(NSDictionary*)transactionDict {
    TransactionOld *transaction = [TransactionOld new];
    transaction.transactionId = [self getObject:@"ID" from:transactionDict];
    transaction.paymentMethodKey = [self getObject:@"PaymentMethodKey" from:transactionDict];
    transaction.paymentMethodGroupKey = [self getObject:@"PaymentMethodGroupKey" from:transactionDict];
    transaction.autoCode = [self getObject:@"AutoCode" from:transactionDict];
    transaction.amount = [self getObject:@"Amount" from:transactionDict];
    transaction.displayName = [self getObject:@"PaymentDisplay" from:transactionDict];
    transaction.insertDate = [self getReadableDate:[self getObject:@"InsertDate" from:transactionDict]];
    transaction.currencyIso = [self getObject:@"CurrencyIso" from:transactionDict];
    transaction.comment = [self getObject:@"Comment" from:transactionDict];
    transaction.phone = [self getObject:@"Phone" from:transactionDict];
    transaction.email = [self getObject:@"Email" from:transactionDict];
    transaction.text = [self getObject:@"Text" from:transactionDict];
    transaction.fullName = [self getObject:@"FullName" from:transactionDict];
    transaction.receiptText = [self getObject:@"ReceiptText" from:transactionDict];
    transaction.receiptLink = [self getObject:@"ReceiptLink" from:transactionDict];
    
    NSDictionary *merchantDictionary = [self getObject:@"Merchant" from:transactionDict];
    if (merchantDictionary != nil) transaction.merchant = [self parseMerchant:merchantDictionary];
    
    NSDictionary *billingDictionary = [self getObject:@"BillingAddress" from:transactionDict];
    if (billingDictionary != nil) transaction.billingAddress = [self parseBillingAddress:billingDictionary];
    
    NSDictionary *shippingDictionary = [self getObject:@"ShippingAddress" from:transactionDict];
    if (shippingDictionary != nil) transaction.shippingAddress = [self parseShippingAddress:shippingDictionary];
    
    return transaction;
}

-(BOOL)validatePassword:(NSString*)password {
    int numOfDigits = 0, numOfChars = 0;
    if ([password length] < 8) return NO;
    for (int i = 0; i < [password length]; i++) {
        char chrValue = [password characterAtIndex:i];
        if(chrValue >= '0' && chrValue <= '9') numOfDigits ++;
        else numOfChars++;
    }
    if (numOfDigits < 2) return NO;
    if (numOfChars < 2) return NO;
    return YES;
}

- (NSMutableDictionary*)createAddressDictionaryWithAddressTitle:(NSString *)title address1:(NSString *)address1 address2:(NSString *)address2 city:(NSString *)city countryIso:(NSString *)countryIso stateIso:(NSString *)stateIso zipCode:(NSString *)zipCode comment:(NSString *)comment addressId:(NSString *)addressId isDefault:(BOOL)isDefault {
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:[self getNonNilValueForString:title] forKey:@"Title"];
    [params setObject:[self getNonNilValueForString:address1] forKey:@"AddressLine1"];
    [params setObject:[self getNonNilValueForString:address2] forKey:@"AddressLine2"];
    [params setObject:[self getNonNilValueForString:city] forKey:@"City"];
    [params setObject:[self getNonNilValueForString:countryIso] forKey:@"CountryIso"];
    [params setObject:[self getNonNilValueForString:stateIso] forKey:@"StateIso"];
    [params setObject:[self getNonNilValueForString:zipCode] forKey:@"PostalCode"];
    [params setObject:[NSNumber numberWithBool:isDefault] forKey:@"IsDefault"];
    [params setObject:[self getNonNilValueForString:comment] forKey:@"Comment"];
    if (addressId != nil) [params setObject:addressId forKey:@"ID"];
    
    return params;
}

- (NSMutableDictionary*)createCardDictionaryWithCardNumber:(NSString *)cardNumber accountValue2:(NSString*)accountValue2 cardId:(NSString *)cardId title:(NSString*)title expMonth:(NSInteger)expMonth expYear:(NSInteger)expYear paymentMethodKey:(NSString *)paymentMethodKey paymentMethodGroupKey:(NSString *)paymentMethodGroupKey iconUrl:(NSString*)iconUrl display:(NSString*)display ownerName:(NSString *)ownerName isDefault:(BOOL)isDefault usesDefaultAddress:(BOOL)usesDefaultAddress address1:(NSString *)address1 address2:(NSString *)address2 city:(NSString *)city countryIso:(NSString *)countryIso stateIso:(NSString *)stateIso zipCode:(NSString *)zipCode {
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:15];
    [components setMonth:expMonth];
    [components setYear:expYear];
    NSDate *date = [NSCalendar.currentCalendar dateFromComponents:components];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"];
    NSString *expDate = [dateFormatter stringFromDate:date];
    
    if (cardId == nil) cardId = @"0";
    NSMutableDictionary *mainDict = [NSMutableDictionary new];
    [mainDict setObject:[self getNonNilValueForString:cardId] forKey:@"ID"];
    [mainDict setObject:[self getNonNilValueForString:title] forKey:@"Title"];
    [mainDict setObject:[self getNonNilValueForString:paymentMethodKey] forKey:@"PaymentMethodKey"];
    [mainDict setObject:[self getNonNilValueForString:paymentMethodGroupKey] forKey:@"PaymentMethodGroupKey"];
    [mainDict setObject:[self getNonNilValueForString:ownerName] forKey:@"OwnerName"];
    [mainDict setObject:[self getNonNilValueForString:expDate] forKey:@"ExpirationDate"];
    [mainDict setObject:[NSNumber numberWithBool:isDefault] forKey:@"IsDefault"];
    [mainDict setObject:[self getNonNilValueForString:iconUrl] forKey:@"Icon"];
    [mainDict setObject:[self getNonNilValueForString:display] forKey:@"Display"];
    [mainDict setObject:[self getNonNilValueForString:cardNumber] forKey:@"AccountValue1"];
    [mainDict setObject:[self getNonNilValueForString:accountValue2] forKey:@"AccountValue2"];
    //Last4Digits
    NSMutableDictionary *billingAddressDict = [NSMutableDictionary new];
    if (!usesDefaultAddress) {
        [billingAddressDict setObject:[self getNonNilValueForString:address1] forKey:@"AddressLine1"];
        [billingAddressDict setObject:[self getNonNilValueForString:address2] forKey:@"AddressLine2"];
        [billingAddressDict setObject:[self getNonNilValueForString:city] forKey:@"City"];
        [billingAddressDict setObject:[self getNonNilValueForString:zipCode] forKey:@"PostalCode"];
        [billingAddressDict setObject:[self getNonNilValueForString:countryIso] forKey:@"CountryIso"];
        [billingAddressDict setObject:[self getNonNilValueForString:stateIso] forKey:@"StateIso"];
    }
    [mainDict setObject:billingAddressDict forKey:@"BillingAddress"];
    
    return mainDict;
}

@end