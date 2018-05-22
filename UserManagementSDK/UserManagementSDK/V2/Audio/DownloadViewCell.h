//
//  DownloadViewCellTableViewCell.h
//  Mahala
//
//  Created by Vitaliy Stepanov on 15.08.14.
//  Copyright (c) 2014 Udi Azulay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartItem.h"

@interface DownloadViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *productNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *merchantNameLabel;

@end
