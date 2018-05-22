//
//  MobileManagement.h
//  UserManagementSDK
//
//  Created by Lev T on 10/02/16.
//  Copyright © 2016 Sapdan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkManagerOld.h"

@interface MobileManagement : NetworkManagerOld

@property (strong, nonatomic) NSString *credentialsToken;
+ (MobileManagement *)getInstance;

-(void)loginWithEmail:(NSString*)email userName:(NSString*)userName password:(NSString*)password callback:(void (^)(bool success, NSString* message))callback;

@end