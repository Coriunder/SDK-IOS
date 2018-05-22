//
//  CustomerSDKCustomers.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods to perform requests to the Customer service related to customer data

#import "Coriunder.h"
#import "ServiceResult.h"
#import "Customer.h"

@interface CustomerSDKCustomers : Coriunder

/**
 * Get instance for CustomerSDKCustomers class.
 * In case there is no current instance, a new one will be created
 * @return CustomerSDKCustomers instance
 */
+ (CustomerSDKCustomers*)getInstance;



/**
 ToDoV2:
 Link
 **/
/**
 * Get info about current user (profile image is not included, call getImageForUserWithId:asRaw:callback: to get it).
 * @param callback will be called after request completion
 */
- (void)getCustomerWithCallback:(void (^)(BOOL success, Customer* customer, NSString* message))callback;

/**
 * Get profile image of any user
 *
 * @param userId id of the user whose profile image has to be loaded
 * @param asRaw set whether image has to be returned as raw
 * @param callback will be called after request completion
 */
- (void)getImageForUserWithId:(NSString*)userId asRaw:(BOOL)asRaw callback:(void (^)(BOOL success, UIImage* image, NSString* message))callback;

/**
 * Register a new user.
 *
 * @param password password to set
 * @param pinCode pin code to set
 * @param email user's email
 * @param firstName user's name
 * @param lastName user's surname
 * @param callback will be called after request completion
 */
- (void)registerUserWithPassword:(NSString*)password pinCode:(NSString*)pinCode email:(NSString*)email firstName:(NSString*)firstName lastName:(NSString*)lastName callback:(void (^)(BOOL success, ServiceResult *result, NSString* message))callback;

/**
 ToDoV2:
 Link 2sht
 **/
/**
 * Save/Update profile info for current user
 *
 * @param firstName user's name
 * @param lastName user's surname
 * @param email user's email
 * @param addressLine1 user's main address
 * @param addressLine2 user's secondary address
 * @param city user's city
 * @param countryIso user's country ISO. List of country ISO codes can be received using method
 *                   getCountriesStatesAndLanguages from InternationalService SDK
 * @param postalCode user's address postal code
 * @param stateIso user's state ISO if any. List of state ISO codes can be received using method
 *                 getCountriesStatesAndLanguages from InternationalService SDK
 * @param cellNumber cell phone number
 * @param birthDate date of birth
 * @param personalNumber user's social security number
 * @param phoneNumber user's phone
 * @param profileImage image which should be set as user profile image
 * @param callback will be called after request completion
 */
- (void)saveCustomerWithFirstName:(NSString*)firstName lastName:(NSString*)lastName email:(NSString*)email addressLine1:(NSString*)addressLine1 addressLine2:(NSString*)addressLine2 city:(NSString*)city countryIso:(NSString*)countryIso postalCode:(NSString*)postalCode stateIso:(NSString*)stateIso cellNumber:(NSString*)cellNumber birthDate:(NSDate*)birthDate personalNumber:(NSString*)personalNumber phoneNumber:(NSString*)phoneNumber profileImage:(UIImage *)profileImage callback:(void (^)(BOOL success, Customer* customer, NSString* message))callback;

@end
