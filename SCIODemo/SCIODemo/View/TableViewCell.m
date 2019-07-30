//
//  TableViewCell.m
//  ZYDataCollectionDemo
//
//  Created by Daniel Chuang on 2019/3/5.
//  Copyright © 2019年 Daniel Chuang. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _clickView.userInteractionEnabled = true;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickViewClick)];
    [_clickView addGestureRecognizer:tap];
}

- (void)clickViewClick {
    
    NSLog(@"clickView");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
