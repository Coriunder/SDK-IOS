//
//  HistoryActivityIndicatorCell.m
//  OOOPS
//
//  Created by Lev T on 28/03/16.
//  Copyright © 2016 Sapdan. All rights reserved.
//

#import "HistoryActivityIndicatorCell.h"

@implementation HistoryActivityIndicatorCell

- (void)awakeFromNib {
    if ([self.contentView respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        self.contentView.preservesSuperviewLayoutMargins = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end