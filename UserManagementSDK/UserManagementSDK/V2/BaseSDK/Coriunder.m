//
//  Coriunder.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Base class for setting up connection

#import "Coriunder.h"
#import "UserSession.h"
#import "KeychainItemWrapper.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Coriunder

- (void)sendPostRequestWithParameters:(NSDictionary *)params withMethod:(NSString *)method callback:(void (^)(BOOL success, id resultObject))completion {
    
    // Creating URL for request
    NSString *requestString = [NSString stringWithFormat:@"%@/%@", [self getServiceUrl], method];
    NSURL *requestURL = [[NSURL alloc] initWithString:requestString];
    
    if ([self logsEnabled]) NSLog(@"%@\nRequest:\n%@", requestURL, params);
    
    // Setting operation manager
    AFHTTPSessionManager *operationManager = [[AFHTTPSessionManager alloc] initWithBaseURL:requestURL];
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // Setting headers
    // Add content type header
    [operationManager.requestSerializer setValue:@"application/json"
                              forHTTPHeaderField:@"Content-Type"];
    // Add app token header
    [operationManager.requestSerializer setValue:[self getAppToken]
                              forHTTPHeaderField:@"applicationToken"];
    // Add signature header. Don't forget to check signature!
    [operationManager.requestSerializer setValue:[self createSignature:params]
                              forHTTPHeaderField:@"Signature"];
    // Add credentials token header
    if ([self isUserLoggedIn])
        [operationManager.requestSerializer setValue:[UserSession getInstance].credentialsToken
                                  forHTTPHeaderField:[UserSession getInstance].credentialsHeader];
    
    // Post request
    [operationManager POST:requestString
                parameters:params
                  progress:nil
                   success:^(NSURLSessionTask *task, id responseObject) {
                       if (responseObject && [self logsEnabled]) NSLog(@"Response:\n%@", responseObject);
                       completion(YES,responseObject);
                       
                   } failure:^(NSURLSessionTask* operation, NSError* error) {
                       NSString* errorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                       if ([self logsEnabled]) NSLog(@"Response:\n%@",errorResponse);
                       
                       NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)operation.response;
                       if (httpResponse.statusCode == 403) {
                           // Session expired, stop it
                           [[UserSession getInstance] resetSession];
                           // Clear auto-login data
                           [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:DEFAULTS_USERNAME];
                           [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:DEFAULTS_EMAIL];
                           [[NSUserDefaults standardUserDefaults] synchronize];
                           
                           NSString *identifier = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
                           KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:identifier accessGroup:nil];
                           [keychainItem resetKeychainItem];
                       }
                       
                       completion(NO, error);
                   }];
}

- (void)sendGetRequestWithParameters:(NSDictionary *)params withMethod:(NSString *)method callback:(void (^)(BOOL success, id resultObject))completion {
    
    // Creating URL for request
    NSString *requestString = [NSString stringWithFormat:@"%@/%@", [self getServiceUrl], method];
    NSURL *requestURL = [[NSURL alloc] initWithString:requestString];
    
    // Setting operation manager
    AFHTTPSessionManager *operationManager = [[AFHTTPSessionManager alloc] initWithBaseURL:requestURL];
    operationManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    if ([UserSession getInstance].credentialsToken.length != 0 && [UserSession getInstance].credentialsHeader.length != 0)
        [operationManager.requestSerializer setValue:[UserSession getInstance].credentialsToken
                                  forHTTPHeaderField:[UserSession getInstance].credentialsHeader];
    
    // Get request
    [operationManager GET:requestString
               parameters:params
                 progress:nil
                  success:^(NSURLSessionTask *task, id responseObject) {
                      completion(YES,responseObject);
                  } failure:^(NSURLSessionTask* operation, NSError* error) {
                      completion(NO, error);
                  }];
}

/**
 * Create request signature to put it as header
 * @return request signature header value
 */
-(NSString*)createSignature:(NSDictionary*)params {
    // creating NSData from the salt
    NSString *salt = [self getSalt];
    NSData *saltData = [NSData dataWithData:[salt dataUsingEncoding:NSUTF8StringEncoding]];
    
    // creating NSData from the request body
    NSError *serializationError = nil;
    NSData *paramData = nil;
    if (params != nil) paramData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&serializationError];
    
    // creating common NSMutableData from salt and body NSData objects
    NSMutableData *concatenatedData = [NSMutableData data];
    if (paramData != nil) [concatenatedData appendData:paramData];
    [concatenatedData appendData:saltData];
    
    // encoding value
    unsigned char hashedCharacters[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256([concatenatedData bytes], (int)[concatenatedData length], hashedCharacters);
    NSData *resultData = [NSData dataWithBytes:hashedCharacters length:CC_SHA256_DIGEST_LENGTH];
    NSString *base64Hash = [resultData base64EncodedStringWithOptions:nil];
    
    return [NSString stringWithFormat:@"bytes-SHA256, %@", base64Hash];
}

/**
 * Detect whether logs are enabled
 * @return logs state
 */
-(BOOL)logsEnabled {
    return [[self getDataWithKey:@"enableLogs"] boolValue];
}

/**
 * Get salt for signature
 * @return salt
 */
-(NSString*)getSalt {
    return [self getDataWithKey:@"salt"];
}

-(void)setAppToken:(NSString*)appToken {
    [[NSUserDefaults standardUserDefaults] setObject:(appToken.length == 0 ? @"" : appToken) forKey:DEFAULTS_APPTOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString*)getAppToken {
    NSString *customAppToken = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULTS_APPTOKEN];
    return customAppToken.length == 0 ? [self getDataWithKey:@"appToken"] : customAppToken;
}

-(void)setServiceUrl:(NSString*)url {
    if (url.length != 0 && ![url containsString:@"http://"] && ![url containsString:@"https://"])
        url = [NSString stringWithFormat:@"http://%@",url];
    
    [[NSUserDefaults standardUserDefaults] setObject:(url.length == 0 ? @"" : url) forKey:DEFAULTS_URL];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString*)getServiceUrl {
    NSString *customUrl = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULTS_URL];
    NSString *defaultUrl = [self getDataWithKey:@"serviceURL"];
    return [NSString stringWithFormat:@"%@%@", customUrl.length == 0 ? defaultUrl : customUrl, self.serviceUrlPart];
}

- (BOOL)isUserLoggedIn {
    return [UserSession getInstance].credentialsToken.length != 0 && [UserSession getInstance].credentialsHeader.length != 0;
}

/**
 * Get specified data from plist
 * @param key reqiured data key
 * @return required data
 */
-(NSString*)getDataWithKey:(NSString*)key {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CoriunderSetup" ofType:@"plist"];
    NSDictionary* configDictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    return [configDictionary objectForKey:key];
}

@end
