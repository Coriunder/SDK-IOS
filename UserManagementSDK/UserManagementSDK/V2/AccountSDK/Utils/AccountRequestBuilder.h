//
//  AccountRequestBuilder.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods designed to prepare
//  NSDictionary to send with requests to Account service

#import <Foundation/Foundation.h>

@interface AccountRequestBuilder : NSObject

/**
 * Prepare NSDictionary for DecodeLoginCookie request
 * @param cookie the cookie you need to decode
 * @param appToken current application token
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForDecodeCookie:(NSString*)cookie appToken:(NSString*)appToken;

/**
 * Prepare NSDictionary for DeviceActivate request
 * @param deviceId current device ID
 * @param code activation code for the device
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForActivateDevice:(NSString*)deviceId activationCode:(NSString*)code;

/**
 * Prepare NSDictionary for DeviceSendActivationCode request
 * @param deviceId current device ID
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForSendCode:(NSString*)deviceId;

/**
 * Prepare NSDictionary for Login request
 * @param email user's email
 * @param userName username for the user which is going to log in
 * @param password user's password
 * @param appName name of the application
 * @param deviceId current device ID
 * @param pushToken send your push token here if you want the app to receive pushes
 * @param setCookie set whether app needs to set cookie
 * @param appToken current application token
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForLogin:(NSString*)email userName:(NSString*)userName password:(NSString*)password
                           appName:(NSString*)appName deviceId:(NSString*)deviceId
                         pushToken:(NSString*)pushToken setCookie:(BOOL)setCookie appToken:(NSString*)appToken;

/**
 * Prepare NSDictionary for RegisterDevice request
 * @param deviceId current device ID
 * @param number phone number to receive SMS with the activation code
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForRegisterDevice:(NSString*)deviceId phoneNumber:(NSString*)number;

/**
 * Prepare NSDictionary for ResetPassword request
 * @param email email of the user which needs to reset his password
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForResetPass:(NSString*)email;

/**
 * Prepare NSDictionary for UpdatePassword request
 * @param newPassword new password for the account
 * @param oldPassword old password for the account
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForSetPass:(NSString*)newPassword oldPassword:(NSString*)oldPassword;

/**
 * Prepare NSDictionary for UpdatePincode request
 * @param newPinCode new pin code for the account
 * @param password password for the account
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForSetPin:(NSString*)newPincode password:(NSString*)password;

@end