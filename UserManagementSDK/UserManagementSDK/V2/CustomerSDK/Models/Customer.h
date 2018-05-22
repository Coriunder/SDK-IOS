//
//  CustomerInfo.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Information about logged in user

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Address.h"

@interface Customer : NSObject

@property (strong, nonatomic) Address *address;
@property (strong, nonatomic) NSString *cellNumber;
@property (strong, nonatomic) NSString *customerNumber; //user id
@property (strong, nonatomic) NSDate *dateOfBirth;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *personalNumber;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) UIImage *userImage;
@property long profileImageSize;
@property (strong, nonatomic) NSDate *registrationDate;

@end