//
//  GetFriendsModel.h

//
//  Created by v_stepanov on 26.01.15.
//  Copyright (c) 2015 OBL Computer Network. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FriendOld : NSObject

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *fullName;
@property (nonatomic) id relationType;
@property (strong, nonatomic) UIImage *profileImage;


@end
