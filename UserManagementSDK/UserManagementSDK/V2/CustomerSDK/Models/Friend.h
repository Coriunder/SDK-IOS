//
//  Friend.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Information about other user's account

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Friend : NSObject

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) UIImage *profileImage;
@property int relationType;

@end
