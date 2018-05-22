//
//  CustomerSDKFriends.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods to perform requests to the Customer service related to friends

#import "Coriunder.h"
#import "ServiceResult.h"
#import "Friend.h"

@interface CustomerSDKFriends : Coriunder

/**
 * Get instance for CustomerSDKFriends class.
 * In case there is no current instance, a new one will be created
 * @return CustomerSDKFriends instance
 */
+ (CustomerSDKFriends*)getInstance;



/**
 * Find user by name or id.
 *
 * @param nameOrId user's name or id to perform search
 * @param page number of the page with results, minimum value is 1
 * @param pageSize results amount per page
 * @param callback will be called after request completion
 */
- (void)findFriendByIdOrName:(NSString*)nameOrId page:(int)page pageSize:(int)pageSize callback:(void (^)(BOOL success, ServiceResult *result, NSMutableArray<Friend*>* friendsArray, NSString* message))callback;

/**
 * Send friend request to exact user.
 *
 * @param friendId id of the user you want to send friend request to
 * @param callback will be called after request completion
 */
- (void)sendFriendRequestToUserWithID:(NSString*)friendId callback:(void (^)(BOOL success, ServiceResult *result, NSMutableArray<Friend*>* friendsArray, NSString* message))callback;

/**
 * Get all friend requests for current user.
 *
 * @param callback will be called after request completion
 */
- (void)getAllFriendRequestsWithCallback:(void (^)(BOOL success, ServiceResult *result, NSMutableArray<Friend*>* friendsArray, NSString* message))callback;

/**
 * Get exact friend request for current user.
 *
 * @param friendId id of the user whose request you want to get info about
 * @param callback will be called after request completion
 */
- (void)getFriendRequestWithFriendId:(NSString*)friendId callback:(void (^)(BOOL success, ServiceResult *result, NSMutableArray<Friend*>* friendsArray, NSString* message))callback;

/**
 ToDoV2:
 Link
 **/
/**
 * Get list of all friends of current user and info about each friend (profile images are not
 * included, call getImageForUser from the CustomerService for each user to get corresponding image).
 *
 * @param callback will be called after request completion
 */
- (void)getFriendsListWithCallback:(void (^)(BOOL success, ServiceResult *result, NSMutableArray<Friend*>* friendsArray, NSString* message))callback;

/**
 ToDoV2:
 Link
 **/
/**
 * Get info about exact friend of the current user (profile image is not included, call
 * getImageForUser from the CustomerService to get friend's profile image).
 *
 * @param friendId id of the user which info has to be loaded
 * @param callback will be called after request completion
 */
- (void)getFriendWithId:(NSString*)friendId callback:(void (^)(BOOL success, ServiceResult *result, NSMutableArray<Friend*>* friendsArray, NSString* message))callback;

/**
 * Import user's friends from Facebook
 *
 * @param accessToken user's Facebook access token
 * @param callback will be called after request completion
 */
- (void)importFacebookFriendsWithAccessToken:(NSString*)accessToken callback:(void (^)(BOOL success, NSString* message))callback;

/**
 * Remove exact user from the friends' list of current user.
 *
 * @param friendId id of the user which has to be removed from the friends' list
 * @param callback will be called after request completion
 */
- (void)removeFriendWithId:(NSString*)friendId callback:(void (^)(BOOL success, ServiceResult *result, NSString* message))callback;

/**
 * Aprrove or decline exact friend request.
 *
 * @param friendId id of the user whose friend request has to approved or declined
 * @param approve defines whether friend request has to approved or declined
 * @param callback will be called after request completion
 */
- (void)replyFriendRequestToFriendWithID:(NSString*)friendId approve:(BOOL)approve callback:(void (^)(BOOL success, ServiceResult *result, NSString* message))callback;

/**
 * Set relation with exact user from the friend list of current user.
 *
 * @param relation relation type to set
 * @param friendId id of the user you are going to set relation with
 * @param callback will be called after request completion
 */
- (void)setFriendRelation:(int)relation withFriend:(NSString*)friendId callback:(void (^)(BOOL success, ServiceResult *result, NSString* message))callback;

@end
