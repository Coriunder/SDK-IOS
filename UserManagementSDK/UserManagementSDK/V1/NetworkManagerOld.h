//
//  NetworkManagerOld.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef NS_ENUM(NSUInteger, typeSerializer) {
    responseJSON,
    responseNONE,
};

@interface NetworkManagerOld : NSObject

@property (strong, nonatomic) NSString *plistName;

- (void)sendPostRequestWithParameters:(NSDictionary *)params withMethod:(NSString *)method credentialsToken:(NSString*)credentialsToken responseSerializer:(typeSerializer)responseSerializer callback:(void (^)(BOOL success, id resultObject))completion;
- (void)sendGetRequestWithParameters:(NSDictionary *)params withMethod:(NSString *)method credentialsToken:(NSString*)credentialsToken callback:(void (^)(BOOL success, id resultObject))completion;

- (NSString*)getAppToken;
- (NSString*)getServiceUrl;

- (id)getObject:(NSString*)name from:(NSDictionary*)dict;
- (NSDictionary*)getDictionary:(NSString*)name from:(NSDictionary*)dict;
- (NSArray*)getArray:(NSString*)name from:(NSDictionary*)dict;
- (NSString*)getString:(NSString*)name from:(NSDictionary*)dict;
- (long)getLong:(NSString*)name from:(NSDictionary*)dict;
- (int)getInt:(NSString*)name from:(NSDictionary*)dict;
- (double)getDouble:(NSString*)name from:(NSDictionary*)dict;
- (BOOL)getBool:(NSString*)name from:(NSDictionary*)dict;

- (BOOL)isEmptyOrNil:(NSString*)value;
- (NSString*)getNonNilValueForString:(NSString*)string;
- (NSDate*)getReadableDate:(NSString*)dateString;
- (BOOL)isRequestSuccessful:(id)resultObject;
- (NSString*)getMessage:(id)resultObject;

@end