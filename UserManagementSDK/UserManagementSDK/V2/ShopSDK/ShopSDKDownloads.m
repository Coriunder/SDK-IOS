//
//  ShopSDKDownloads.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods to perform requests to the Shop service related to downloads

#import "ShopSDKDownloads.h"
#import "ShopRequestBuilder.h"
#import "ShopParser.h"

@implementation ShopSDKDownloads

static ShopSDKDownloads *_instance = nil;
static ShopRequestBuilder *builder;
static ShopParser *parser;

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.serviceUrlPart = @"Shop.svc";
        builder = [ShopRequestBuilder new];
        parser = [ShopParser new];
    }
    return self;
}

+ (ShopSDKDownloads *)getInstance {
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [ShopSDKDownloads new];
        }
    }
    return _instance;
}

/************************************ REQUESTS SECTION START ************************************/

/*
 ToDoV2:
 no success parser
 */
- (void)downloadItemWithId:(long)itemId asPlainData:(BOOL)asPlainData callback:(void (^)(BOOL success, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForDownload:itemId asPlainData:asPlainData];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"Download" callback:^(BOOL success, id resultObject) {
        if (success) {
            // Parse response
            
        } else {
            if (callback) callback(NO, [parser parseError:resultObject]);
        }
    }];
}

/*
 ToDoV2:
 no success parser
 */
- (void)downloadItemWithKey:(NSString*)fileKey asPlainData:(BOOL)asPlainData callback:(void (^)(BOOL success, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForDownloadUnauthorized:fileKey asPlainData:asPlainData];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"DownloadUnauthorized" callback:^(BOOL success, id resultObject) {
        if (success) {
            // Parse response
            
        } else {
            if (callback) callback(NO, [parser parseError:resultObject]);
        }
    }];
}

- (void)getDownloadsOnPage:(int)page pageSize:(int)pageSize callback:(void (^)(BOOL success, NSMutableArray<CartItem*> *downloads, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForDownloads:page pageSize:pageSize];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"GetDownloads" callback:^(BOOL success, id resultObject) {
        if (success) {
            // Parse response
            NSArray *result = [parser getArray:@"d" from:resultObject];
            NSMutableArray *cartItems = [parser parseCartItems:result];
            if (callback != nil) callback(YES, cartItems, @"");
        } else {
            if (callback) callback(NO, [NSMutableArray new], [parser parseError:resultObject]);
        }
    }];
}

/************************************* REQUESTS SECTION END *************************************/

@end
