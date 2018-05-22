//
//  UserInfoModel.h

//
//  Created by v_stepanov on 29.01.15.
//  Copyright (c) 2015 OBL Computer Network. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CustomerOld : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *customerNumber; //user id
@property (strong, nonatomic) NSString *address1;
@property (strong, nonatomic) NSString *address2;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *zipCode;
@property (strong, nonatomic) NSString *stateIso;
@property (strong, nonatomic) NSString *countryIso;
@property (strong, nonatomic) UIImage *userImage;
@property (strong, nonatomic) NSString *cellNumber;
@property (strong, nonatomic) NSDate *dateOfBirth;
@property (strong, nonatomic) NSString *personalNumber;
@property (strong, nonatomic) NSString *profileImageSize;
@property (strong, nonatomic) NSDate *registrationDate;

@end
