//
//  DownloadView.h
//  Mahala
//
//  Created by Vitaliy Stepanov on 14.08.14.
//  Copyright (c) 2014 Udi Azulay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadView : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *emptyView;

@end