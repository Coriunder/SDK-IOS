//
//  DownloadViewCellTableViewCell.m
//  Mahala
//
//  Created by Vitaliy Stepanov on 15.08.14.
//  Copyright (c) 2014 Udi Azulay. All rights reserved.
//

#import "DownloadViewCell.h"

@implementation DownloadViewCell

- (void)awakeFromNib {
    if ([self.contentView respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        self.contentView.preservesSuperviewLayoutMargins = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end