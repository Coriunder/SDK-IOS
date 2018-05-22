//
//  UserManagement.h

//
//  Created by v_stepanov on 19.11.14.
//  Copyright (c) 2014 OBL Computer Network. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "NetworkManagerOld.h"
#import "CustomerOld.h"
#import "TransactionOld.h"
#import "PaymentMethodOld.h"
#import "ShipmentAddressOld.h"

@interface UserManagement : NetworkManagerOld

@property (strong, nonatomic) NSString *credentialsToken;
+ (UserManagement *)getInstance;

/**
 * Register new user and automatically login this user after successful registration.
 * Login data is automatically stored for future logins.
 *
 * @param
 * - firstName - user name, can't be empty or nil
 * - lastName - user surname, can't be empty or nil
 * - password - password to set, can't be empty or nil, should contain at least 9 symbols
 *   including 2 chars
 *   and 2 numbers, can't be empty or nil
 * - pinCode - pincode to set, can't be empty or nil
 * - email - user email, can't be empty or nil
 * - pushToken - send app push token here in case you want your app to receive push notifications from server
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSDictionary *respons - NSDictionary containing useful data like UserId, LastLogin, IsFirstLogin,
 *   VersionUpdateRequired (nil in case login after registration was NOT successful)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)registerUserWithName:(NSString*)firstName surname:(NSString*)lastName password:(NSString*)password pinCode:(NSString*)pinCode email:(NSString*)email pushToken:(NSString *)pushToken callback:(void (^)(BOOL success, NSDictionary *response, NSString* message))callback;

/**
 * Check whether user can be signed up with specified email
 *
 * @param
 * - email - user email, can't be empty or nil
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)checkUserEmail:(NSString *)email callback:(void (^)(BOOL success, NSString *message))callback;

/**
 * Check whether user is logged in or not
 */
- (BOOL)isUserLoggedIn;

/**
 * Login for existing users. Login data is automatically stored for future logins.
 *
 * @param
 * - email - user email, can't be empty or nil
 * - password - user password, can't be empty or nil
 * - pushToken - send app push token here in case you want your app to receive push notifications from server
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSDictionary *respons - NSDictionary containing useful data like UserId, LastLogin, IsFirstLogin,
 *   VersionUpdateRequired (nil in case request was NOT successful)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)loginWithEmail:(NSString *)email password:(NSString *)password pushToken:(NSString *)pushToken callback:(void (^)(BOOL success, NSDictionary *response, NSString *message))callback;

/**
 * Autologin with email and pass stored on previous login.
 *
 * @param
 * - pushToken - send app push token here in case you want your app to receive push notifications from server
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSDictionary *respons - NSDictionary containing useful data like UserId, LastLogin, IsFirstLogin,
 *   VersionUpdateRequired (nil in case request was NOT successful)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)tryAutoLoginWithPushToken:(NSString *)pushToken callback:(void (^)(BOOL success, NSDictionary *response, NSString *message))callback;

/**
 * Reset password for user.
 *
 * @param
 * - email - user email, can't be empty or nil
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)resetPasswordForEmail:(NSString *)email callback:(void (^)(bool success, NSString *message))callback;

/**
 * Log off current user. Also cleans saved login data (email/pass) after successful logoff.
 *
 * @param
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 */
- (void)logOff:(void (^)(bool success))callback;







/**
 * Get text info about current user (profile image is not included; call
 * getImageForUserWithId to get it).
 *
 * @param
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - Customer* customer - object which contains all info about current user
 *   (nil in case request was NOT successful)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)getCustomerWithCallback:(void (^)(bool success, CustomerOld* customer, NSString* message))callback;

/**
 * Save/Update profile info for current user
 *
 * @param
 * - firstName - user name, can't be empty or nil
 * - lastName - user surname, can't be empty or nil
 * - email - user email, can't be empty or nil
 * - address1 - user main address
 * - address2 - user secondary address
 * - city - user city
 * - zipCode - user address zip code
 * - stateIso - user state ISO if any. If not nil, then it should match any of state ISO codes
 *   from the list which can be received using getCountriesAndStatesWithCallback method
 * - countryIso - user country ISO. If not nil, then it should match any of country ISO codes
 *   from the list which can be received using getCountriesAndStatesWithCallback method
 * - phone - user phone
 * - profileImage - image to be set as user profile image
 * - birthDay - day of birth
 * - birthMonth - month of birth
 * - birthYear - year of birth (requires 4 digits)
 * - personalNumber - user social security number
 * - cellNumber - cell phone number
 * - callback.
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - Customer* customer - object which contains all updated info about current user
 *   (nil in case request was NOT successful)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)saveCustomerWithFirstName:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email address1:(NSString *)address1 address2:(NSString *)address2 city:(NSString *)city zipCode:(NSString *)zipCode stateIso:(NSString *)stateIso countryIso:(NSString *)countryIso phone:(NSString *)phone profileImage:(UIImage *)profileImage birthDay:(int)birthDay birthMonth:(int)birthMonth birthYear:(int)birthYear personalNumber:(NSString*)personalNumber cellNumber:(NSString*)cellNumber callback:(void (^)(bool success, CustomerOld* customer, NSString* message))callback;

/**
 * Update password for user
 *
 * @param
 * - newPassword - new password, can't be empty or nil, should contain at least 9 symbols
 *   including 2 chars and 2 numbers
 * - oldPassword - old password, can't be empty or nil
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)setNewPassword:(NSString*)newPassword oldPassword:(NSString*)oldPassword callback:(void (^)(bool success, NSString* message))callback;

/**
 * Update pincode for user
 *
 * @param
 * - newPincode - new pincode, can't be empty or nil
 * - password - current password, can't be empty or nil
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)setNewPincode:(NSString *)newPincode password:(NSString *)password callback:(void (^)(bool success, NSString* message))callback;

/**
 * Get all billing addresses added by current user
 *
 * @param
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSMutableArray* array - array containing BillingAddress objects (nil in case request was NOT
 *   successful)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)getBillingAddressesWithCallback:(void (^)(bool success, NSMutableArray *array, NSString* message))callback;








/**
 * Get exact shipping address by id
 *
 * @param
 * - addressId - id of the required shipping address
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - ShipmentAddress *address - ShipmentAddress object (nil in case request was NOT successful)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)getShippingAddressWithId:(long)addressId callback:(void (^)(BOOL success, ShipmentAddressOld *address, NSString* message))callback;

/**
 * Get all shipping addresses added by current user
 *
 * @param
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSMutableArray* addressesArray - array containing ShipmentAddress objects (nil in case request was NOT
 *   successful)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)getShippingAddressesWithCallback:(void (^)(BOOL success, NSMutableArray* addressesArray, NSString* message))callback;

/**
 * Add/Update shipping address for user
 *
 * @param
 * - title - title for address
 * - address1 - main address for this shipping address
 * - address2 - secondary address for this shipping address
 * - city - city for this shipping address
 * - countryIso - country ISO. If not nil, then it should match any of country ISO codes
 *   from the list which can be received using getCountriesAndStatesWithCallback method
 * - stateIso - state ISO if any. If not nil, then it should match any of state ISO codes
 *   from the list which can be received using getCountriesAndStatesWithCallback method
 * - zipCode - zip code for this shipping address
 * - comment - description for this address
 * - addressId - id of address which has to be updated or nil in case it is a new address
 * - isDefault - defines whether this address should be set as default address or not
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)saveShippingAddressWithTitle:(NSString *)title address1:(NSString *)address1 address2:(NSString *)address2 city:(NSString *)city countryIso:(NSString *)countryIso stateIso:(NSString *)stateIso zipCode:(NSString *)zipCode comment:(NSString *)comment addressId:(NSString *)addressId isDefault:(BOOL)isDefault callback:(void (^)(bool success, NSString* message))callback;

/**
 * Update several shipping address for user at once
 *
 * @param
 * - shippingAddresses - array containing ShippingAddress object for each address which has
 *   to be updated, can't be empty or nil. Each ShippingAddress object should already contain
 *   all changes which have to be done for exact address
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)saveShippingAddresses:(NSArray*)shippingAddresses callback:(void (^)(bool success, NSString* message))callback;

/**
 * Delete exact shipping address
 *
 * @param
 * - addressId - id of address which has to be deleted, can't be empty or nil
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)deleteShippingAddressWithId:(NSString *)addressId callback:(void (^)(bool success, NSString* message))callback;








/**
 * Get exact payment method by id
 *
 * @param
 * - cardId - id of the required payment method
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - PaymentMethod *paymentMethod - PaymentMethod object (nil in case request was NOT successful)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)getPaymentMethodWithId:(long)cardId callback:(void (^)(BOOL success, PaymentMethodOld *paymentMethod, NSString* message))callback;

/**
 * Get all payment methods added by current user
 *
 * @param
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSMutableArray* paymentMethodsArray - array containing PaymentMethod objects (nil in case
 *   request was NOT successful)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)getPaymentMethodsWithCallback:(void (^)(BOOL success, NSMutableArray* paymentMethodsArray, NSString* message))callback;

/**
 * Add new payment method for user
 *
 * @param
 * - cardNumber - card number, can't be empty or nil
 * - accountValue2 - secondary card value if any
 * - title - card title
 * - expMonth - card expiry month
 * - expYear - card expiry year (requires 4 digits)
 * - paymentMethodKey - defines card type, should be taken from the default list which could be
 *   received using getPaymentAndRelationListsWithCallback method, can't be empty or nil
 * - paymentMethodGroupKey - defines card type, should be taken from the default list which could be
 *   received using getPaymentAndRelationListsWithCallback method, can't be empty or nil
 * - iconUrl - card icon url
 * - display - card display name
 * - ownerName - card owner name
 * - isDefault - defines whether this payment method should be set as default payment method or not
 * - usesDefaultAddress - defines whether this payment method will have a custom billing address
 *   (value set to NO) or it will use address from the customer info (value set to YES). In case it
 *   will use customer info address fields address1, address2, city, countryIso, stateIso and zipCode
 *   are not required and will be ignored
 * - address1 - main address for this payment method, not required in case usesDefaultAddress
 *   is set to YES
 * - address2 - secondary address for this payment method, not required in case usesDefaultAddress
 *   is set to YES
 * - city - city for this payment method, not required in case usesDefaultAddress is set to YES
 * - countryIso - country ISO. If not nil, then it should match any of country ISO codes
 *   from the list which can be received using getCountriesAndStatesWithCallback method,
 *   not required in case usesDefaultAddress is set to YES
 * - stateIso - state ISO if any. If not nil, then it should match any of state ISO codes
 *   from the list which can be received using getCountriesAndStatesWithCallback method,
 *   not required in case usesDefaultAddress is set to YES
 * - zipCode - zip code for this payment method not required in case usesDefaultAddress is set to YES
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)addNewPaymentMethodWithCardNumber:(NSString *)cardNumber accountValue2:(NSString*)accountValue2 title:(NSString*)title expMonth:(NSInteger)expMonth expYear:(NSInteger)expYear paymentMethodKey:(NSString *)paymentMethodKey paymentMethodGroupKey:(NSString *)paymentMethodGroupKey iconUrl:(NSString*)iconUrl display:(NSString*)display ownerName:(NSString *)ownerName isDefault:(BOOL)isDefault usesDefaultAddress:(BOOL)usesDefaultAddress address1:(NSString *)address1 address2:(NSString *)address2 city:(NSString *)city countryIso:(NSString *)countryIso stateIso:(NSString *)stateIso zipCode:(NSString *)zipCode callback:(void (^)(BOOL success, NSString* message))callback;

/**
 * Update existing payment method for user
 *
 * @param
 * - cardId - id of payment method which has to be updated, can't be empty or nil
 * - accountValue2 - secondary card value if any
 * - title - card title
 * - expMonth - card expiry month
 * - expYear - card expiry year (requires 4 digits)
 * - paymentMethodKey - defines card type, should be taken from the default list which could be
 *   received using getPaymentAndRelationListsWithCallback method, can't be empty or nil
 * - paymentMethodGroupKey - defines card type, should be taken from the default list which could be
 *   received using getPaymentAndRelationListsWithCallback method, can't be empty or nil
 * - iconUrl - card icon url
 * - display - card display name
 * - ownerName - card owner name
 * - isDefault - defines whether this payment method should be set as default payment method or not
 * - usesDefaultAddress - defines whether this payment method will have a custom billing address
 *   (value set to NO) or it will use address from the customer info (value set to YES). In case it
 *   will use customer info address fields address1, address2, city, countryIso, stateIso and zipCode
 *   are not required and will be ignored
 * - address1 - main address for this payment method, not required in case usesDefaultAddress
 *   is set to YES
 * - address2 - secondary address for this payment method, not required in case usesDefaultAddress
 *   is set to YES
 * - city - city for this payment method, not required in case usesDefaultAddress is set to YES
 * - countryIso - country ISO. If not nil, then it should match any of country ISO codes
 *   from the list which can be received using getCountriesAndStatesWithCallback method,
 *   not required in case usesDefaultAddress is set to YES
 * - stateIso - state ISO if any. If not nil, then it should match any of state ISO codes
 *   from the list which can be received using getCountriesAndStatesWithCallback method,
 *   not required in case usesDefaultAddress is set to YES
 * - zipCode - zip code for this payment method not required in case usesDefaultAddress is set to YES
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)updatePaymentMethodWithId:(NSString *)cardId accountValue2:(NSString*)accountValue2 title:(NSString*)title expMonth:(NSInteger)expMonth expYear:(NSInteger)expYear paymentMethodKey:(NSString *)paymentMethodKey paymentMethodGroupKey:(NSString *)paymentMethodGroupKey iconUrl:(NSString*)iconUrl display:(NSString*)display ownerName:(NSString *)ownerName isDefault:(BOOL)isDefault usesDefaultAddress:(BOOL)usesDefaultAddress address1:(NSString *)address1 address2:(NSString *)address2 city:(NSString *)city countryIso:(NSString *)countryIso stateIso:(NSString *)stateIso zipCode:(NSString *)zipCode callback:(void (^)(BOOL success, NSString* message))callback;

/**
 * Update several shipping address for user at once
 *
 * @param
 * - paymentMethods - array containing PaymentMethod object for each payment method which has
 *   to be updated, can't be empty or nil. Each PaymentMethod object should already contain
 *   all changes which have to be done for exact payment method
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)savePaymentMethods:(NSArray*)paymentMethods callback:(void (^)(bool success, NSString* message))callback;

/**
 * Delete exact payment method
 *
 * @param
 * - cardId - id of the payment method which has to be deleted
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)deletePaymentMethodWithId:(long)cardId callback:(void (^)(bool success, NSString* message))callback;








/**
 * Get list of friends of current user and text info about each friend (profile images are not
 * included; call getImageForUserWithId for each user to get corresponding image).
 *
 * @param
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSMutableArray* friendsArray - array containing Friend objects (nil in case request was NOT successful)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)getFriendListWithCallback:(void (^)(bool success, NSMutableArray* friendsArray, NSString* message))callback;

/**
 * Get text info about exact friend of  the current user (profile image is not included; call
 * getImageForUserWithId to get it).
 *
 * @param
 * - friendId - id of the user which info has to be loaded, can't be nil
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSMutableArray* friendsArray - array containing one Friend object (nil in case request was NOT successful)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)getFriendWithId:(id)friendId callback:(void (^)(bool success, NSMutableArray* friendsArray, NSString* message))callback;

/**
 * Find user by name or id. Returns results by pages.
 *
 * @param
 * - nameOrId - user name or id to perform search, can't be nil
 * - page - number of the page with results, minimum value is 1
 * - pageSize - results amount per page
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSMutableArray* friendsArray - array containing Friend objects (nil in case request was NOT successful)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)findFriendByIdOrName:(NSString *)nameOrId page:(int)page pageSize:(int)pageSize callback:(void (^)(bool success, NSMutableArray* friendsArray, NSString* message))callback;

/**
 * Remove exact user from the firend list of current user.
 *
 * @param
 * - friendId - id of the user which has to be removed from the friend list, can't be nil
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)removeFriendWithId:(NSString *)friendId callback:(void (^)(bool success, NSString* message))callback;

/**
 * Set relation with exact user from the firend list of current user.
 *
 * @param
 * - relation - relation type (key) to set, available relation types and their names
 *   can be received using getPaymentAndRelationListsWithCallback method
 * - friendId - id of the user you are going to set relation with, can't be nil
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)setFriendRelation:(int)relation withFriend:(NSString*)friendId callback:(void (^)(bool success, NSString* message))callback;








/**
 * Send friend request to exact user.
 *
 * @param
 * - friendId - id of the user you want to send friend request to, can't be nil
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)sendFriendRequestToUserWithID:(NSString *)friendId callback:(void (^)(bool success, NSString* message))callback;

/**
 * Get friend requests for current user.
 *
 * @param
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSMutableArray* friendsArray - array containing Friend objects (nil in case request was NOT successful)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)getFriendRequestsWithCallback:(void (^)(bool success, NSMutableArray* friendsArray, NSString* message))callback;

/**
 * Aprrove or decline exact friend request.
 *
 * @param
 * - friendId - id of the user whose friend request has to approved or declined, can't be nil
 * - approve - defines whether friend request has to approved (value YES) or declined (value NO)
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)replyFriendRequestToFriendWithID:(NSString *)friendId approve:(BOOL)approve callback:(void (^)(bool success, NSString* message))callback;








/**
 * Process exact cart. Should be called separately for each cart.
 *
 * @param
 * - cartCookie - cookie of the cart which has to be processed, can't be empty or nil
 * - merchantNumber - number of the merchant, can't be empty or nil
 * - totalPrice - total cart price, can't be empty or nil
 * - cartCurrencyIso - currency ISO for the cart, can't be empty or nil
 * - pin - current user pincode, can't be empty or nil
 * - paymentMethodId - id of the current user payment method, which has to be used to
 *   process the cart, can't be empty or nil
 * - addressId - id of the current user shipping address, which has to be used to
 *   process the cart, can't be empty or nil
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)processCartWithCookie:(NSString*)cartCookie merchantNumber:(NSString*)merchantNumber totalPrice:(float)totalPrice cartCurrencyIso:(NSString*)cartCurrencyIso pin:(NSString*)pin paymentMethodId:(NSString*)paymentMethodId addressId:(NSString*)addressId callback:(void (^)(bool success, NSString* message))callback;

/**
 * Get info about exact transaction.
 *
 * @param
 * - transactionId - id of the transaction which info has to be loaded, can't be empty or nil
 * - callback.
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - Transaction *transaction - Transaction object for the requested transaction (nil in case request
 *   was NOT successful)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)getTransactionWithId:(NSString*)transactionId callback:(void (^)(BOOL success, TransactionOld *transaction, NSString* message))callback;

/**
 * Get all transactions for the current user. Returns results by pages.
 *
 * @param
 * - page - number of the page with results, minimum value is 1
 * - pageSize - results amount per page
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSMutableArray* transactions - array containing Transaction object (nil in case request
 *   was NOT successful)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)getTransactionsOnPage:(int)page pageSize:(int)pageSize callback:(void (^)(BOOL success, NSMutableArray *transactions, NSString* message))callback;








/**
 * Get available types of payment methods and relations.
 *
 * @param
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSMutableArray *paymentGroups - array containing PaymentCardRootGroup objects
 *   (nil in case request was NOT successful)
 * - NSMutableArray *relations - array containing Relation objects (nil in case request
 *   was NOT successful)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)getPaymentAndRelationListsWithCallback:(void (^)(BOOL success, NSMutableArray *paymentGroups, NSMutableArray *relations, NSString* message))callback;

/**
 * Get profile image of any user
 *
 * @param
 * - userId - id of the user whose profile image has to be loaded, can't be empty or nil
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - UIImage* image - image for requested user (nil in case request was NOT successful)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)getImageForUserWithId:(id)userId callback:(void (^)(bool success, UIImage* image, NSString* message))callback;

/**
 * Get URL for profile image of any user. Returns NSString for the user image URL
 *
 * @param
 * - userId - id of the user whose profile image URL has to be created
 */
- (NSString*)getImageUrl:(NSString*)userId;

/**
 * Get list of countries, states and their ISO codes
 *
 * @param
 * - callback
 *
 * @callback
 * - BOOL success - completion status (whether request was successful or not)
 * - NSMutableDictionary *resultDictionary - dictionary containing countries and states (nil in case
 *   request was NOT successful)
 * - NSString* message - error description if any (nil in case request was successful)
 */
- (void)getCountriesAndStatesWithCallback:(void (^)(BOOL success, NSMutableDictionary *resultDictionary, NSString* message))callback;

@end