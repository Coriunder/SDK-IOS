//
//  MerchantSDK.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods to perform requests to the Merchant service

#import "Coriunder.h"
#import "RegistrationMerchant.h"

@interface MerchantSDK : Coriunder

/**
 * Get instance for MerchantSDK class.
 * In case there is no current instance, a new one will be created
 * @return MerchantSDK instance
 */
+ (MerchantSDK *)getInstance;



/**
 * Register as a merchant
 * @param merchant RegistrationMerchant object for the merchant which has to be registered
 * @param callback will be called after request completion
 */
- (void)registerMerchant:(RegistrationMerchant*)merchant callback:(void (^)(BOOL success, NSString* message))callback;

@end
