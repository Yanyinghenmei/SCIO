//
//  ZYVisualSelectorWindow.m
//  ZYDataCollectionDemo
//
//  Created by Daniel Chuang on 2019/3/4.
//  Copyright © 2019年 Daniel Chuang. All rights reserved.
//

#import "ZYVisualSelectorWindow.h"
#import "ZYVisualSelectorController.h"

@implementation ZYVisualSelectorWindow {
    __weak ZYVisualSelectorController * _rootVC;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        ZYVisualSelectorController *rootVC = [ZYVisualSelectorController new];
        self.rootViewController = rootVC;
        _rootVC = rootVC;
    }
    return self;
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [_rootVC touchesBegan:touches withEvent:event];
//}

@end
