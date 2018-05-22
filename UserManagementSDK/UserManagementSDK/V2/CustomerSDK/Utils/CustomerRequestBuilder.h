//
//  CustomerRequestBuilder.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods designed to prepare
//  NSDictionary to send with requests to Customer service

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ShippingAddress.h"

@interface CustomerRequestBuilder : NSObject

/**
 * Prepare NSDictionary for GetImage request
 * @param userId id of the user which image has to be loaded
 * @param asRaw set whether result should be raw
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForGetImage:(NSString*)userId asRaw:(BOOL)asRaw;

/**
 * Prepare NSDictionary for RegisterCustomer request
 * @param password password to set
 * @param pinCode pin code to set
 * @param email user's email
 * @param firstName user's name
 * @param lastName user's surname
 * @param appToken current application token
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForRegisterCustomer:(NSString*)password pinCode:(NSString*)pinCode email:(NSString*)email
                                    firstName:(NSString*)firstName lastName:(NSString*)lastName appToken:(NSString*)appToken;

/**
 * Prepare NSDictionary for SaveCustomer request
 * @param firstName user's name
 * @param lastName user's surname
 * @param email user's email
 * @param addressLine1 user's main address
 * @param addressLine2 user's secondary address
 * @param city user's city
 * @param countryIso user's country ISO. List of country ISO codes can be received using method
 *                   getCountriesStatesAndLanguagesWithCallback from International SDK
 * @param postalCode user's address postal code
 * @param stateIso user's state ISO if any. List of state ISO codes can be received using method
 *                 getCountriesStatesAndLanguagesWithCallback from International SDK
 * @param cellNumber cell phone number
 * @param birthDate date of birth
 * @param personalNumber user's social security number
 * @param phoneNumber user's phone
 * @param profileImage image which should be set as user profile image
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForSaveCustomer:(NSString*)firstName lastName:(NSString*)lastName email:(NSString*)email
                             addressLine1:(NSString*)addressLine1 addressLine2:(NSString*)addressLine2 city:(NSString*)city
                               countryIso:(NSString*)countryIso postalCode:(NSString*)postalCode stateIso:(NSString*)stateIso
                               cellNumber:(NSString*)cellNumber birthDate:(NSDate*)birthDate personalNumber:(NSString*)personalNumber
                              phoneNumber:(NSString*)phoneNumber profileImage:(UIImage*)profileImage;

/**
 * Prepare JSONObject for FindFriend request
 * @param nameOrId user's name or id to perform search
 * @param page number of the page with results, minimum value is 1
 * @param pageSize results amount per page
 * @return prepared JSONObject
 */
- (NSDictionary*)buildJsonForFindFriend:(NSString*)nameOrId page:(int)page pageSize:(int)pageSize;

/**
 * Prepare NSDictionary for FriendRequest request
 * @param friendId id of the user you want to send friend request to
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForFriendRequest:(NSString*)friendId;

/**
 * Prepare NSDictionary for GetFriendRequests request
 * @param friendId id of the user whose request you want to get info about
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForGetFriendRequests:(NSString*)friendId;

/**
 * Prepare NSDictionary for GetFriends request
 * @param friendId id of the user which info has to be loaded
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForGetFriends:(NSString*)friendId;

/**
 * Prepare NSDictionary for ImportFriendsFromFacebook request
 * @param accessToken user's Facebook access token
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForImportFb:(NSString*)accessToken;

/**
 * Prepare NSDictionary for RemoveFriend request
 * @param friendId id of the user which has to be removed from the friends' list
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForRemoveFriend:(NSString*)friendId;

/**
 * Prepare NSDictionary for ReplyFriendRequest request
 * @param friendId id of the user whose friend request has to approved or declined
 * @param approve defines whether friend request has to approved or declined
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForReplyRequest:(NSString*)friendId approve:(BOOL)approve;

/**
 * Prepare NSDictionary for SetFriendRelation request
 * @param relation relation type to set
 * @param friendId id of the user you are going to set relation with
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForRelation:(int)relation withFriend:(NSString*)friendId;

/**
 * Prepare NSDictionary for DeleteShippingAddress request
 * @param addressId id of address which has to be deleted
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForDeleteAddress:(long)addressId;

/**
 * Prepare NSDictionary for GetShippingAddress request
 * @param addressId id of the required shipping address
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForGetAddress:(long)addressId;

/**
 * Prepare NSDictionary for SaveShippingAddress request
 * @param params NSDictionary containing shipping address data
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForSaveAddress:(NSDictionary*)params;

/**
 * Prepare NSDictionary for SaveShippingAddresses request
 * @param shippingAddresses NSArray containing ShippingAddress objects for shipping addresses
 *                          which have to be updated.
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildJsonForSaveAddresses:(NSArray<ShippingAddress*>*)shippingAddresses;

/**
 * Create NSDictionary from ShippingAddress object
 * @param address ShippingAddress object to be parsed to NSDictionary
 * @param isNew detects whether it is a new shipping address
 * @return prepared NSDictionary
 */
- (NSDictionary*)buildAddressJson:(ShippingAddress*)address isNew:(BOOL)isNew;

@end