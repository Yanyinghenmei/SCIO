//
//  ZYNodeSelectorView.m
//  ZYDataCollectionDemo
//
//  Created by Daniel Chuang on 2019/3/4.
//  Copyright © 2019年 Daniel Chuang. All rights reserved.
//

#import "ZYNodeSelectorView.h"
#import "ZYViewDataHelper.h"
#import "UIView+ZYNode.h"
#import "UIControl+ZYAnalysis.h"
#import "ZYHeader.h"

@interface ZYNodeSelectorView ()
@property (nonatomic,weak) UIView *selectView;
@property (nonatomic,strong) UIView *selectColorView;
@end

@implementation ZYNodeSelectorView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
        self.layer.cornerRadius = frame.size.width/2;
        self.clipsToBounds = true;
    }
    return self;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint centerInSuperView = [touches.anyObject locationInView:self.superview];
    self.center = centerInSuperView;
    
    // 去掉选中状态
    if (_selectView || ![self pointInside:[touches.anyObject locationInView:_selectView] withEvent:event]) {
        if (_selectColorView) [_selectColorView removeFromSuperview];
        _selectView = nil;
    }
    
    // 设为选中状态
    UIWindow *rootWindow = [UIApplication sharedApplication].windows[0];
    UIView *responderView = [rootWindow hitTest:[touches.anyObject locationInView:rootWindow] withEvent:nil];
    
    // viewController.view 不在这里选择
    if ([responderView isViewOfViewController]) {
        return;
    }
    // 暂不支持textField/textView 圈选
    if ([responderView isKindOfClass:UITextView.class] ||
        [responderView isKindOfClass:UITextField.class]) {
        return;
    }
    
    // 暂不支持网页
    if ([responderView superViewOrSelfWithClass:UIWebView.class] ||
        [responderView superViewOrSelfWithClass:NSClassFromString(@"WkWebView")]) {
        return;
    }
    // 暂不统计scrollView的滑动等事件
    if ([responderView isKindOfClass:[UIScrollView class]]) {
        return;
    }
    
    // 没有交互的元素不能圈选
    if ((!responderView.gestureRecognizers.count || !responderView.userInteractionEnabled) &&
        ![responderView isKindOfClass:UIControl.class]) {
        return;
    }
    
    if (responderView && _selectColorView != responderView) {
        _selectView = responderView;
        
        // 展示选中状态
        [_selectView addSubview:self.selectColorView];
        self.selectColorView.frame = responderView.bounds;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_selectView) {
        
        // 去掉选中状态
        _selectView.layer.cornerRadius = 0;
        _selectView.layer.borderColor = [UIColor clearColor].CGColor;
        _selectView.layer.borderWidth = 0;
        if (_selectColorView) [_selectColorView removeFromSuperview];
        
        NSDictionary *dic = [ZYViewDataHelper getAnalysisDataWithView:_selectView];
        
        // 处理数据 -- 上传 -- 圈选的视图数据, 不对统计行为有影响, 只是对事件起别名,
        // TODO: 设置别名 -- 上传数据
        ZYPrintf(@"%@",dic);
    }
}

- (UIView *)selectColorView {
    if (!_selectColorView) {
        _selectColorView = [[UIView alloc] initWithFrame:CGRectZero];
        _selectColorView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
        _selectColorView.layer.borderColor = [[UIColor redColor] colorWithAlphaComponent:0.8].CGColor;
        _selectColorView.layer.borderWidth = 1.0f;
        _selectColorView.layer.cornerRadius = 10;
        _selectColorView.clipsToBounds = true;
    }
    return _selectColorView;
}

@end
