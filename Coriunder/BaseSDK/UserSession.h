//
//  UserSession.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Class which holds data about the user's session and deals with it

#import <Foundation/Foundation.h>

@interface UserSession : NSObject

@property (strong, nonatomic) NSString *credentialsToken;
@property (strong, nonatomic) NSString *credentialsHeader;
/**
 * Get instance for UserSession class.
 * In case there is no current instance, a new one will be created
 * @return UserSession instance
 */
+ (UserSession*)getInstance;



/**
 * Reset current session
 */
- (void)resetSession;

@end
