//
//  AccountSDK.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods to perform requests to the Account service

#import "Coriunder.h"
#import "CookieDecodeResult.h"
#import "LoginResult.h"

@interface AccountSDK : Coriunder

/**
 * Get instance for AccountSDK class.
 * In case there is no current instance, a new one will be created
 * @return AccountSDK instance
 */
+ (AccountSDK*)getInstance;



/**
 * Decode login cookie
 *
 * @param cookie the cookie you need to decode
 * @param callback will be called after request completion
 */
- (void)decodeLoginCookie:(NSString*)cookie callback:(void (^)(BOOL success, CookieDecodeResult *result, NSString *message))callback;

/**
 ToDoV2:
 Link
 **/
/**
 * Device activation
 *
 * @param activationCode activation code for the device. Call sendActivationCodeForDeviceWithId:callback: to get it.
 * @param callback will be called after request completion
 */
- (void)activateDeviceWithId:(NSString*)deviceId activationCode:(NSString*)code callback:(void (^)(BOOL success, NSString *message))callback;

/**
 * Request SMS with an activation code for current device
 *
 * @param callback will be called after request completion
 */
- (void)sendActivationCodeForDeviceWithId:(NSString*)deviceId callback:(void (^)(BOOL success, NSString *message))callback;

/**
 * Log current user out. Successful request also cleans data used for auto login.
 *
 * @param callback will be called after request completion
 */
-(void)logOff:(void (^)(BOOL success, NSString *message))callback;

/**
 ToDoV2:
 Link
 **/
/**
 * Login for existing users. Successful request also stores login data to log user in automatically
 * in future. This data is being cleared when logOff: is called.
 *
 * @param email user's email
 * @param userName username for the user which is going to log in
 * @param password user's password
 * @param appName name of the application
 * @param deviceId current device id
 * @param pushToken send your push token here if you want the app to receive pushes
 * @param setCookie set whether app needs to set cookie
 * @param callback will be called after request completion
 */
- (void)loginWithEmail:(NSString*)email userName:(NSString*)userName password:(NSString*)password appName:(NSString*)appName deviceId:(NSString*)deviceId pushToken:(NSString*)pushToken setCookie:(BOOL)setCookie callback:(void (^)(BOOL success, LoginResult *result, NSString *message))callback;

/**
 * Register device in the system
 *
 * @param deviceId current device id
 * @param number phone number to receive SMS with the activation code
 * @param callback will be called after request completion
 */
- (void)registerDeviceWithId:(NSString*)deviceId phoneNumber:(NSString*)number callback:(void (^)(BOOL success, ServiceResult *result, NSString *message))callback;

/**
 * Reset password for user.
 *
 * @param email email of the user which needs to reset his password
 * @param callback will be called after request completion
 */
- (void)resetPasswordForEmail:(NSString*)email callback:(void (^)(BOOL success, NSString *message))callback;

/**
 * Update user's password
 *
 * @param newPassword new password for the account
 * @param oldPassword old password for the account
 * @param callback will be called after request completion
 */
- (void)setNewPassword:(NSString*)newPassword oldPassword:(NSString*)oldPassword callback:(void (^)(BOOL success, ServiceResult *result, NSString* message))callback;

/**
 * Update user's pin code
 *
 * @param newPincode new pin code for the account
 * @param password password for the account
 * @param callback will be called after request completion
 */
- (void)setNewPincode:(NSString*)newPincode password:(NSString*)password callback:(void (^)(BOOL success, ServiceResult *result, NSString* message))callback;

/**
 ToDoV2:
 Link
 **/
/**
 * Try autologin with data stored on previous login
 *
 * @param pushToken send your push token here if you want the app to receive pushes
 * @param callback will be called after request completion
 */
- (void)tryAutoLoginWithPushToken:(NSString*)pushToken callback:(void (^)(BOOL success, LoginResult *result, NSString *message))callback;

@end
