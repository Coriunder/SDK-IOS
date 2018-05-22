//
//  BaseParser.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Commonly used parser methods

#import "BaseParser.h"
#import "AFNetworking.h"

@implementation BaseParser

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
        return [[NSArray alloc] initWithArray:value];
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

- (NSDate*)getReadableDate:(NSString*)name from:(NSDictionary*)dict {
    NSString *dateString = [self getString:name from:dict];
    if (dateString.length == 0) return nil;
    NSRange start = [dateString rangeOfString:@"("];
    NSRange end = [dateString rangeOfString:@")"];
    NSRange dateRange = NSMakeRange(start.location + start.length, end.location - start.location - start.length);
    NSString *millis = [dateString substringWithRange:dateRange];
    if (millis.length == 0) return [NSDate new];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:([millis longLongValue]/1000)];
    return date;
}

- (ServiceResult*)parseServiceResult:(NSDictionary*)dict {
    ServiceResult *result = [ServiceResult new];
    [result setCode:[self getInt:@"Code" from:dict]];
    [result setIsSuccess:[self getBool:@"IsSuccess" from:dict]];
    [result setKey:[self getString:@"Key" from:dict]];
    [result setMessage:[self getString:@"Message" from:dict]];
    [result setNumber:[self getString:@"Number" from:dict]];
    return result;
}

- (Address*)parseAddress:(NSDictionary*)addressDict {
    Address *address = [Address new];
    if (addressDict == nil) return address;
    [address setAddress1:[self getString:@"AddressLine1" from:addressDict]];
    [address setAddress2:[self getString:@"AddressLine2" from:addressDict]];
    [address setCity:[self getString:@"City" from:addressDict]];
    [address setCountryIso:[self getString:@"CountryIso" from:addressDict]];
    [address setPostalCode:[self getString:@"PostalCode" from:addressDict]];
    [address setStateIso:[self getString:@"StateIso" from:addressDict]];
    return address;
}

- (Merchant*)parseMerchant:(NSDictionary*)merchantDict {
    Merchant *merchant = [Merchant new];
    if (merchantDict == nil) return merchant;
    [merchant setAddress:[self parseAddress:[self getDictionary:@"Address" from:merchantDict]]];
    [merchant setCurrencies:[self getArray:@"Currencies" from:merchantDict]];
    [merchant setEmail:[self getString:@"Email" from:merchantDict]];
    [merchant setFaxNumber:[self getString:@"FaxNumber" from:merchantDict]];
    [merchant setGroup:[self getString:@"Group" from:merchantDict]];
    [merchant setLanguages:[self getArray:@"Languages" from:merchantDict]];
    [merchant setName:[self getString:@"Name" from:merchantDict]];
    [merchant setNumber:[self getString:@"Number" from:merchantDict]];
    [merchant setPhone:[self getString:@"PhoneNumber" from:merchantDict]];
    [merchant setWebsite:[self getString:@"WebsiteUrl" from:merchantDict]];
    return merchant;
}

- (void (^)(BOOL success, id resultObject))createServiceCallbackWithUserCallback:(void (^)(BOOL success, ServiceResult *result, NSString *message))callback {
    
    return ^(BOOL success, id resultObject) {
        if (success) {
            if (resultObject != nil) {
                // Parse response to ServiceResult object
                NSDictionary *dict = [self getDictionary:@"d" from:resultObject];
                ServiceResult *result = [self parseServiceResult:dict];
                if (callback) callback(result.isSuccess, result, result.message);
            } else {
                if (callback) callback(NO, [ServiceResult new], NSLocalizedStringFromTable(@"EmptyResponseError", @"CoriunderStrings", @""));
            }
        } else {
            if (callback) callback(NO, [ServiceResult new], [self parseError:resultObject]);
        }
    };
}

- (void (^)(BOOL success, id resultObject))createServiceMultiCallbackWithUserCallback:(void (^)(BOOL success, ServiceMultiResult *result, NSString *message))callback {
    
    return ^(BOOL success, id resultObject) {
        if (success) {
            ServiceMultiResult *result = [ServiceMultiResult new];
            if (resultObject != nil) {
                // Parse response to ServiceMultiResult object
                NSDictionary *dict = [self getDictionary:@"d" from:resultObject];
                [result setCode:[self getInt:@"Code" from:dict]];
                [result setIsSuccess:[self getBool:@"IsSuccess" from:dict]];
                [result setKey:[self getString:@"Key" from:dict]];
                [result setMessage:[self getString:@"Message" from:dict]];
                [result setNumber:[self getString:@"Number" from:dict]];
                [result setRecordNumber:[self getLong:@"RecordNumber" from:dict]];
                [result setRefNumbers:[self getArray:@"RefNumbers" from:dict]];
                
                if (callback) callback(result.isSuccess, result, result.message);
            } else {
                if (callback) callback(NO, result, NSLocalizedStringFromTable(@"EmptyResponseError", @"CoriunderStrings", @""));
            }
        } else {
            if (callback) callback(NO, [ServiceMultiResult new], [self parseError:resultObject]);
        }
    };
}

- (void (^)(BOOL success, id resultObject))createBasicCallbackWithUserCallback:(void (^)(BOOL success, NSString *message))callback getSuccess:(BOOL)getSuccess {
    
    return ^(BOOL success, id resultObject) {
        if (success) {
            if (callback) callback(getSuccess ? [self getBool:@"d" from:resultObject] : YES, @"");
        } else {
            if (callback) callback(NO, [self parseError:resultObject]);
        }
    };
}

- (NSString*)parseError:(NSError*)error {
    NSString *errorText = @"";
    NSData *responseData = (NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    if (responseData != nil && ![responseData isKindOfClass:[NSNull class]]) {
        id json = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
        if (json) errorText = [json objectForKey:@"Message"];
        if (errorText.length == 0) errorText = error.localizedDescription;
    } else {
        errorText = error.localizedDescription;
    }
    return errorText;
}

@end
