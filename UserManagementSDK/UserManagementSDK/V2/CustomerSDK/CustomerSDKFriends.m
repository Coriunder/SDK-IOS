//
//  CustomerSDKFriends.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods to perform requests to the Customer service related to friends

#import "CustomerSDKFriends.h"
#import "CustomerRequestBuilder.h"
#import "CustomerParser.h"

@implementation CustomerSDKFriends

static CustomerSDKFriends *_instance = nil;
static CustomerRequestBuilder *builder;
static CustomerParser *parser;

-(id)init {
    self = [super init];
    if (self) {
        // Setting default non-nil values
        self.serviceUrlPart = @"Customer.svc";
        builder = [CustomerRequestBuilder new];;
        parser = [CustomerParser new];
    }
    return self;
}

+ (CustomerSDKFriends *)getInstance {
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [CustomerSDKFriends new];
        }
    }
    return _instance;
}

/************************************ REQUESTS SECTION START ************************************/

- (void)findFriendByIdOrName:(NSString*)nameOrId page:(int)page pageSize:(int)pageSize callback:(void (^)(BOOL success, ServiceResult *result, NSMutableArray<Friend*>* friendsArray, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForFindFriend:nameOrId page:page pageSize:pageSize];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"FindFriend" callback:[self createFriendsCallbackWithUserCallback:callback]];
}

- (void)sendFriendRequestToUserWithID:(NSString*)friendId callback:(void (^)(BOOL success, ServiceResult *result, NSMutableArray<Friend*>* friendsArray, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForFriendRequest:friendId];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"FriendRequest" callback:[self createFriendsCallbackWithUserCallback:callback]];
}

- (void)getAllFriendRequestsWithCallback:(void (^)(BOOL success, ServiceResult *result, NSMutableArray<Friend*>* friendsArray, NSString* message))callback {
    [self getFriendRequestWithFriendId:nil callback:callback];
}

- (void)getFriendRequestWithFriendId:(NSString*)friendId callback:(void (^)(BOOL success, ServiceResult *result, NSMutableArray<Friend*>* friendsArray, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForGetFriendRequests:friendId];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"GetFriendRequests" callback:[self createFriendsCallbackWithUserCallback:callback]];
}

- (void)getFriendsListWithCallback:(void (^)(BOOL success, ServiceResult *result, NSMutableArray<Friend*>* friendsArray, NSString* message))callback {
    [self getFriendWithId:nil callback:callback];
}

- (void)getFriendWithId:(NSString*)friendId callback:(void (^)(BOOL success, ServiceResult *result, NSMutableArray<Friend*>* friendsArray, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForGetFriends:friendId];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"GetFriends" callback:[self createFriendsCallbackWithUserCallback:callback]];
}

- (void)importFacebookFriendsWithAccessToken:(NSString*)accessToken callback:(void (^)(BOOL success, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForImportFb:accessToken];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"ImportFriendsFromFacebook" callback:[parser createBasicCallbackWithUserCallback:callback getSuccess:NO]];
}

- (void)removeFriendWithId:(NSString*)friendId callback:(void (^)(BOOL success, ServiceResult *result, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForRemoveFriend:friendId];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"RemoveFriend" callback:[parser createServiceCallbackWithUserCallback:callback]];
    
}

- (void)replyFriendRequestToFriendWithID:(NSString*)friendId approve:(BOOL)approve callback:(void (^)(BOOL success, ServiceResult *result, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForReplyRequest:friendId approve:approve];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"ReplyFriendRequest" callback:[parser createServiceCallbackWithUserCallback:callback]];
    
}

- (void)setFriendRelation:(int)relation withFriend:(NSString*)friendId callback:(void (^)(BOOL success, ServiceResult *result, NSString* message))callback {
    
    // Create NSDictionary to send with request
    NSDictionary *params = [builder buildJsonForRelation:relation withFriend:friendId];
    
    // Create request
    [self sendPostRequestWithParameters:params withMethod:@"SetFriendRelation" callback:[parser createServiceCallbackWithUserCallback:callback]];
}

/************************************* REQUESTS SECTION END *************************************/

/**
 * @param callback callback to be called on request result
 * @return listener which parses result to NSMutableArray containing
 *      Friend objects and to ServiceResult object and calls the callback
 */
- (void (^)(BOOL success, id resultObject))createFriendsCallbackWithUserCallback:(void (^)(BOOL success, ServiceResult *result, NSMutableArray<Friend*> *friends, NSString *message))callback {
    
    return ^(BOOL success, id resultObject) {
        if (success) {
            if (resultObject != nil) {
                NSDictionary *dict = [parser getDictionary:@"d" from:resultObject];
                // Parse ServiceResult
                ServiceResult *result = [parser parseServiceResult:dict];
                // Parse friends' data
                NSMutableArray *friends = [parser parseFriendsResponse:dict];
                if (callback) callback(result.isSuccess, result, friends, result.message);
            } else {
                if (callback) callback(NO, [ServiceResult new], [NSMutableArray new], NSLocalizedStringFromTable(@"EmptyResponseError", @"CoriunderStrings", @""));
            }
        } else {
            if (callback) callback(NO, [ServiceResult new], [NSMutableArray new], [parser parseError:resultObject]);
        }
    };
}

@end
