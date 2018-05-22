//
//  NetworkManagerOld.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  

#import "NetworkManagerOld.h"

@implementation NetworkManagerOld

- (void)sendPostRequestWithParameters:(NSDictionary *)params withMethod:(NSString *)method credentialsToken:(NSString*)credentialsToken responseSerializer:(typeSerializer)responseSerializer callback:(void (^)(BOOL success, id resultObject))completion {
    
    // Creating URL for request
    NSString *requestString = [NSString stringWithFormat:@"%@%@", [self getServiceUrl], method];
    NSURL *requestURL = [[NSURL alloc] initWithString:requestString];
    
    // Setting operation manager
    AFHTTPSessionManager *operationManager = [[AFHTTPSessionManager alloc] initWithBaseURL:requestURL];
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    if (responseSerializer == responseJSON) operationManager.responseSerializer = [AFJSONResponseSerializer serializer];
        [operationManager.requestSerializer setValue:@"application/json"
                                  forHTTPHeaderField:@"Content-Type"];
    [operationManager.requestSerializer setValue:[NSString stringWithFormat:@"credentialsToken=%@; HttpOnly", credentialsToken]
                              forHTTPHeaderField:@"Cookie"];
    [operationManager.requestSerializer setValue:[self getAppToken]
                              forHTTPHeaderField:@"applicationToken"];
    
    // Post request
    [operationManager POST:requestString
                parameters:params
                  progress:nil
                   success:^(NSURLSessionTask *task, id responseObject) {
                       completion(YES,responseObject);
                   } failure:^(NSURLSessionTask* operation, NSError* error) {
                       NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                       NSLog(@"%@",ErrorResponse);
                       completion(NO, error);
                   }];
}

- (void)sendGetRequestWithParameters:(NSDictionary *)params withMethod:(NSString *)method credentialsToken:(NSString*)credentialsToken callback:(void (^)(BOOL success, id resultObject))completion {
    
    // Creating URL for request
    NSString *requestString = [NSString stringWithFormat:@"%@%@", [self getServiceUrl], method];
    NSURL *requestURL = [[NSURL alloc] initWithString:requestString];
    
    // Setting operation manager
    AFHTTPSessionManager *operationManager = [[AFHTTPSessionManager alloc] initWithBaseURL:requestURL];
    operationManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [operationManager.requestSerializer setValue:[NSString stringWithFormat:@"credentialsToken=%@", credentialsToken]
                              forHTTPHeaderField:@"Cookie"];
    
    // Get request
    [operationManager GET:requestString
               parameters:params
                 progress:nil
                  success:^(NSURLSessionTask *task, id responseObject) {
                      completion(YES,responseObject);
                  } failure:^(NSURLSessionTask* operation, NSError* error) {
                      NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                      NSLog(@"%@",ErrorResponse);
                      completion(NO, error);
                  }];
}

-(NSString*)getAppToken {
    return [self getDataWithKey:@"appToken"];
}

-(NSString*)getServiceUrl {
    return [self getDataWithKey:@"serviceURL"];
}

-(NSString*)getDataWithKey:(NSString*)key {
    NSString *path = [[NSBundle mainBundle] pathForResource:self.plistName ofType:@"plist"];
    NSDictionary* configDictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    return [configDictionary objectForKey:key];
}

- (id)getObject:(NSString*)name from:(NSDictionary*)dict {
    if (dict != nil && ![[dict objectForKey:name] isKindOfClass:[NSNull class]])
        return [dict objectForKey:name];
    return nil;
}

- (NSDictionary*)getDictionary:(NSString*)name from:(NSDictionary*)dict {
    id value = [self getObject:name from:dict];
    if (value != nil && ![value isKindOfClass:[NSNull class]])
        return value;
    return [NSDictionary new];
}

- (NSArray*)getArray:(NSString*)name from:(NSDictionary*)dict {
    id value = [self getObject:name from:dict];
    if (value != nil && ![value isKindOfClass:[NSNull class]])
        return value;
    return [NSArray new];
}

- (NSString*)getString:(NSString*)name from:(NSDictionary*)dict {
    id value = [self getObject:name from:dict];
    if (value != nil && ![value isKindOfClass:[NSNull class]])
        return [NSString stringWithFormat:@"%@",value];
    return @"";
}

- (long)getLong:(NSString*)name from:(NSDictionary*)dict {
    id value = [self getObject:name from:dict];
    if (value != nil && ![value isKindOfClass:[NSNull class]])
        return [value longValue];
    return 0;
}

- (int)getInt:(NSString*)name from:(NSDictionary*)dict {
    id value = [self getObject:name from:dict];
    if (value != nil && ![value isKindOfClass:[NSNull class]])
        return [value intValue];
    return 0;
}

- (double)getDouble:(NSString*)name from:(NSDictionary*)dict {
    id value = [self getObject:name from:dict];
    if (value != nil && ![value isKindOfClass:[NSNull class]])
        return [value doubleValue];
    return 0;
}

- (BOOL)getBool:(NSString*)name from:(NSDictionary*)dict {
    id value = [self getObject:name from:dict];
    if (value != nil && ![value isKindOfClass:[NSNull class]])
        return [value boolValue];
    return NO;
}

-(BOOL)isEmptyOrNil:(NSString*)value {
    if (value == nil || value.length == 0) return YES;
    return NO;
}

-(NSString*)getNonNilValueForString:(NSString*)string {
    if (string != nil) return string;
    else return @"";
}

-(NSDate*)getReadableDate:(NSString*)dateString {
    if ([dateString isKindOfClass:[NSNull class]] || dateString == nil) return nil;
    NSArray *array1 = [dateString componentsSeparatedByString:@"("];
    if (array1 == nil || (array1 != nil && array1.count < 2)) return nil;
    NSString *separated1 = [array1 objectAtIndex:1];
    NSArray *array2 = [separated1 componentsSeparatedByString:@")"];
    if (array2 == nil || (array2 != nil && array2.count < 1)) return nil;
    NSString *separated2 = [array2 objectAtIndex:0];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:([separated2 longLongValue]/1000)];
    return date;
}

-(BOOL)isRequestSuccessful:(id)resultObject {
    NSDictionary *dict = [self getObject:@"d" from:resultObject];
    if (dict != nil) {
        NSString *successString = [self getObject:@"IsSuccess" from:dict];
        if (successString != nil) return [successString boolValue];
    }
    return NO;
}

-(NSString*)getMessage:(id)resultObject {
    NSDictionary *dict = [self getObject:@"d" from:resultObject];
    if (dict != nil) {
        NSString *message = [self getString:@"Message" from:dict];
        if (message != nil) return message;
    }
    return @"";
}

@end