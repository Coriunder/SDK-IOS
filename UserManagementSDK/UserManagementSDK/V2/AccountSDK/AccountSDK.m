//
//  AccountSDK.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods to perform requests to the Account service

#import "AccountSDK.h"
#import "UserSession.h"
#import "AccountRequestBuilder.h"
#import "AccountParser.h"
#import "KeychainItemWrapper.h"

@implementation AccountSDK

static AccountSDK *_instance = nil;
static AccountRequestBuilder *builder;
static AccountParser *parser;

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.serviceUrlPart = @"Account.svc";
        builder = [AccountRequestBuilder new];
        parser = [AccountParser new];
    }
    return self;
}

+ (AccountSDK *)getInstance {
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [AccountSDK new];
        }
    }
    return _instance;
}

/************************************ REQUESTS SECTION START ************************************/

- (void)decodeLoginCookie:(NSString*)cookie callback:(void (^)(BOOL success, CookieDecodeResult *result, NSString *message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForDecodeCookie:cookie appToken:[self getAppToken]];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"DecodeLoginCookie" callback:^(BOOL success, id resultObject) {
        if (success) {
            if (resultObject != nil) {
                // Parse response
                CookieDecodeResult *result = [parser parseCookieDecoder:resultObject];
                if (callback) callback(result.isSuccess, result, result.message);
            } else {
                if (callback) callback(NO, [CookieDecodeResult new], NSLocalizedStringFromTable(@"EmptyResponseError", @"CoriunderStrings", @""));
            }
        } else {
            if (callback) callback(NO, [CookieDecodeResult new], [parser parseError:resultObject]);
        }
    }];
}

- (void)activateDeviceWithId:(NSString*)deviceId activationCode:(NSString*)code callback:(void (^)(BOOL success, NSString *message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForActivateDevice:deviceId activationCode:code];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"DeviceActivate" callback:[parser createBasicCallbackWithUserCallback:callback getSuccess:YES]];
}

- (void)sendActivationCodeForDeviceWithId:(NSString*)deviceId callback:(void (^)(BOOL success, NSString *message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForSendCode:deviceId];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"DeviceSendActivationCode" callback:[parser createBasicCallbackWithUserCallback:callback getSuccess:YES]];
}

-(void)logOff:(void (^)(BOOL success, NSString *message))callback {
    // Create request
    [self sendPostRequestWithParameters:nil withMethod:@"LogOff" callback:^(BOOL success, id resultObject) {
        if (success) {
            // Stop session
            [[UserSession getInstance] resetSession];
            // Clear auto-login data
            [self updateStoredUsername:@"" andEmail:@"" andPass:@""];
            
            if (callback) callback(YES, @"");
        } else {
            if (callback) callback(NO, [parser parseError:resultObject]);
        }
    }];
}

- (void)loginWithEmail:(NSString*)email userName:(NSString*)userName password:(NSString*)password appName:(NSString*)appName deviceId:(NSString*)deviceId pushToken:(NSString*)pushToken setCookie:(BOOL)setCookie callback:(void (^)(BOOL success, LoginResult *result, NSString *message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForLogin:email userName:userName password:password appName:appName
                                             deviceId:deviceId pushToken:pushToken setCookie:setCookie appToken:[self getAppToken]];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"Login" callback:^(BOOL success, id resultObject) {
        if (success) {
            if (resultObject != nil) {
                // Parse response
                LoginResult *result = [parser parseLoginResult:resultObject];
                
                if (result.isSuccess) {
                    // Start session
                    [[UserSession getInstance] setCredentialsToken:result.credentialsToken];
                    [[UserSession getInstance] setCredentialsHeader:result.credentialsHeader];
                    // Store data for auto-login
                    [self updateStoredUsername:userName andEmail:email andPass:password];
                }
                if (callback) callback(result.isSuccess, result, result.message);
            } else {
                if (callback) callback(NO, [LoginResult new], NSLocalizedStringFromTable(@"EmptyResponseError", @"CoriunderStrings", @""));
            }
        } else {
            // Clear auto-login data if any
            [self updateStoredUsername:@"" andEmail:@"" andPass:@""];
            if (callback) callback(NO, [LoginResult new], [parser parseError:resultObject]);
        }
    }];
}

- (void)registerDeviceWithId:(NSString*)deviceId phoneNumber:(NSString*)number callback:(void (^)(BOOL success, ServiceResult *result, NSString *message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForRegisterDevice:deviceId phoneNumber:number];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"RegisterDevice" callback:[parser createServiceCallbackWithUserCallback:callback]];
}

- (void)resetPasswordForEmail:(NSString*)email callback:(void (^)(BOOL success, NSString *message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForResetPass:email];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"ResetPassword" callback:[parser createBasicCallbackWithUserCallback:callback getSuccess:YES]];
}

- (void)setNewPassword:(NSString*)newPassword oldPassword:(NSString*)oldPassword callback:(void (^)(BOOL success, ServiceResult *result, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForSetPass:newPassword oldPassword:oldPassword];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"UpdatePassword" callback:^(BOOL success, id resultObject) {
        if (success) {
            // Parse response
            NSDictionary *dict = [parser getDictionary:@"d" from:resultObject];
            ServiceResult *result = [parser parseServiceResult:dict];
            
            if (result.isSuccess) {
                // Update password used for auto-login
                KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc]
                                                     initWithIdentifier:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]
                                                     accessGroup:nil];
                [keychainItem setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"] forKey:(id)kSecAttrService];
                [keychainItem setObject:newPassword forKey:(__bridge id)(kSecValueData)];
            }
            
            if (callback) callback(result.isSuccess, result, result.message);
        } else {
            if (callback) callback(NO, [ServiceResult new], [parser parseError:resultObject]);
        }
    }];
}

- (void)setNewPincode:(NSString*)newPincode password:(NSString*)password callback:(void (^)(BOOL success, ServiceResult *result, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForSetPin:newPincode password:password];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"UpdatePincode" callback:[parser createServiceCallbackWithUserCallback:callback]];
}

- (void)tryAutoLoginWithPushToken:(NSString*)pushToken callback:(void (^)(BOOL success, LoginResult *result, NSString *message))callback {
    
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc]
                                         initWithIdentifier:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]
                                         accessGroup:nil];
    NSString *password = [keychainItem objectForKey:(__bridge id)(kSecValueData)];
    NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULTS_EMAIL];
    
    if (email.length > 0 && password.length > 0)
        [self loginWithEmail:email userName:nil password:password appName:nil deviceId:nil pushToken:pushToken setCookie:NO callback:callback];
    else if (callback) callback(NO, [LoginResult new], @"Stored login data not found");
}

/************************************* REQUESTS SECTION END *************************************/

/**
 * Stroe user data
 * @param username username to store
 * @param email email to store
 * @param password password to store
 */
- (void)updateStoredUsername:(NSString*)username andEmail:(NSString*)email andPass:(NSString*)password {
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:DEFAULTS_USERNAME];
    [[NSUserDefaults standardUserDefaults] setObject:email forKey:DEFAULTS_EMAIL];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *identifier = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:identifier accessGroup:nil];
    if (password.length > 0) {
        [keychainItem setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"] forKey:(id)kSecAttrService];
        [keychainItem setObject:password forKey:(__bridge id)(kSecValueData)];
    } else {
        [keychainItem resetKeychainItem];
    }
}

@end
