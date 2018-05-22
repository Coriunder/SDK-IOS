//
//  MerchantRequestBuilder.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods designed to prepare
//  NSDictionary to send with requests to Merchant service

#import <Foundation/Foundation.h>
#import "RegistrationMerchant.h"

@interface MerchantRequestBuilder : NSObject

/**
 * Prepare NSDictionary for Register request
 * @param  merchant RegistrationMerchant object to be parsed to JSONObject
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildRegisterMerchantJson:(RegistrationMerchant*)merchant;

@end
