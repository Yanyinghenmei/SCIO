//
//  ZYVisualSelectorController.m
//  ZYDataCollectionDemo
//
//  Created by Daniel Chuang on 2019/3/4.
//  Copyright © 2019年 Daniel Chuang. All rights reserved.
//

#import "ZYVisualSelectorController.h"
#import "ZYVisualSelectorView.h"

@interface ZYVisualSelectorController ()

@end

@implementation ZYVisualSelectorController

- (void)loadView {
    self.view = [[ZYVisualSelectorView alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
}
@end
