//
//  UIControl+ZYAnalysis.m
//  ZYDataCollectionDemo
//
//  Created by Daniel Chuang on 2019/3/4.
//  Copyright © 2019年 Daniel Chuang. All rights reserved.
//

#import "UIControl+ZYAnalysis.h"
#import "MethodSwizzingTool.h"
#import "UIView+ZYNode.h"
#import "ZYHeader.h"


@implementation UIControl (ZYAnalysis)
+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(sendAction:to:forEvent:);
        SEL swizzingSelector = @selector(zy_sendAction:to:forEvent:);
        [MethodSwizzingTool swizzingForClass:[self class] originalSel:originalSelector swizzingSel:swizzingSelector];
    });
}

// 注意, 如果圈选的元素没有 target 和 action 此方法不会被调用
-(void)zy_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    // 此方法不一定只由系统调用, 需要判断
    if (action && target && event) {
        // 可以收集到的数据-- 逻辑上, 所有数据围绕 self(UIControl)
        NSString *elementPath = [self elementPathWithIndexPath:nil];
        NSString *actionName = NSStringFromSelector(action);
        NSString *targetName = NSStringFromClass([target class]);
        NSString *className = NSStringFromClass(self.class);
        NSString *date = [NSString stringWithFormat:@"%f",[NSDate date].timeIntervalSince1970];
        
        NSString *analysisName = @"";
        if ([self respondsToSelector:@selector(titleForState:)]) {
            analysisName = [(UIButton *)self titleForState:self.selected?UIControlStateSelected:UIControlStateNormal];
        }
        
        // 保存数据
        [[DataCacheManager shareManager] saveEventDataWithSessionId:[[ZYGlobalInfoHelper shareHelper] sessionId] targetName:targetName actionName:actionName className:className elementPath:elementPath analysisName:analysisName date:date indexPath:nil selected:self.selected tag:self.tag];
    }
    
    [self zy_sendAction:action to:target forEvent:event];
}

- (NSArray *)targetActionArray {
    // 视图绑定的事件标识 target+action+tag+UIControlEvents
    NSMutableArray *result = [NSMutableArray array];
    
    NSArray *targets = self.allTargets.allObjects;
    
    for (id target in targets) {
        NSString *targetName = NSStringFromClass([target class]);
        UIControlEvents events = self.allControlEvents;
        
        NSUInteger kDisplaceStep = 0;                       //!< 偏移位数
        static long long const kDisplacementBase = 0x01;    //!< 偏移基数
        
        for (; kDisplaceStep < 32; ++ kDisplaceStep) {
            if (events & (kDisplacementBase << kDisplaceStep)) {
                UIControlEvents eventType = (UIControlEvents)(kDisplacementBase << kDisplaceStep);
                NSArray *actions = [self actionsForTarget:target forControlEvent:eventType];
                
                for (NSString *action in actions) {
                    NSDictionary *dic = @{p_targetName:targetName,p_actionName:action};
                    [result containsObject:dic] ?: [result addObject:dic];
                }
            }
        }
    }
    return result.copy;
}

@end
