//
//  ZYVisualSelectorView.m
//  ZYDataCollectionDemo
//
//  Created by Daniel Chuang on 2019/3/4.
//  Copyright © 2019年 Daniel Chuang. All rights reserved.
//

#import "ZYVisualSelectorView.h"
#import "ZYNodeSelectorView.h"

@implementation ZYVisualSelectorView {
    ZYNodeSelectorView *_arrowView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _arrowView = [[ZYNodeSelectorView alloc] initWithFrame:CGRectMake(100, 300, 50, 50)];
        [self addSubview:_arrowView];
    }
    return self;
}

// 响应转发
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if ([_arrowView pointInside:[self convertPoint:point toView:_arrowView]  withEvent:event]) {
        return [super hitTest:point withEvent:event];
    }
    
    UIWindow *rootWindow = [UIApplication sharedApplication].windows[0];
    UIView *responderView = [rootWindow hitTest:point withEvent:event];
    
    if (responderView) {
        return responderView;
    }
    
    return [super hitTest:point withEvent:event];
}



@end
