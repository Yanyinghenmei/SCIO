//
//  UIGestureRecognizer+ZYAnalysis.m
//  ZYDataCollectionDemo
//
//  Created by Daniel Chuang on 2019/3/5.
//  Copyright © 2019年 Daniel Chuang. All rights reserved.
//

#import "UIGestureRecognizer+ZYAnalysis.h"
#import "MethodSwizzingTool.h"
#import "DataContainer.h"
#import <objc/runtime.h>
#import "UIView+ZYNode.h"
#import "ZYHeader.h"


#define targetAssName @"target_associated_name"
#define methodAssName @"method_associated_name"

@implementation UIGestureRecognizer (ZYAnalysis)

- (void)setMethodName:(NSString *)methodName {
    objc_setAssociatedObject(self, methodAssName, methodName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)methodName {
    return objc_getAssociatedObject(self, methodAssName);
}
- (void)setTargetName:(NSString *)targetName {
    objc_setAssociatedObject(self, targetAssName, targetName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)targetName {
    return objc_getAssociatedObject(self, targetAssName);
}


+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [MethodSwizzingTool swizzingForClass:[self class] originalSel:@selector(initWithTarget:action:) swizzingSel:@selector(zy_initWithTarget:action:)];
    });
}

- (instancetype)zy_initWithTarget:(nullable id)target action:(nullable SEL)action
{
    UIGestureRecognizer *selfGestureRecognizer = [self zy_initWithTarget:target action:action];
    
    if (!target || !action) {
        return selfGestureRecognizer;
    }
    
    // 暂不统计scrollView的滑动等事件
    if ([target isKindOfClass:[UIScrollView class]]) {
        return selfGestureRecognizer;
    }
    
    Class class = [target class];
    SEL originalSEL = action;
    
    //将gesture的对应的sel存储到 methodName属性中，主要是方便 responseUser_gesture： 方法中取出来
    self.methodName = NSStringFromSelector(action);
    self.targetName = NSStringFromClass(class);
    
    //给原对象添加一共名字为 “sel_name”的方法，并将方法的实现指向本类中的 responseUser_gesture：方法的实现
    NSString * sel_name = [self tempSelName];
    SEL swizzledSEL =  NSSelectorFromString(sel_name);
    BOOL suc = class_addMethod(class,
                               swizzledSEL,
                               method_getImplementation(class_getInstanceMethod([self class], @selector(responseUser_gesture:))),
                               nil);
    
    if (suc) {
        [MethodSwizzingTool swizzingForClass:class originalSel:originalSEL swizzingSel:swizzledSEL];
    }
    
    return selfGestureRecognizer;
}

-(void)responseUser_gesture:(UIGestureRecognizer *)gesture {
    
    // 替换掉的方法, 也可能不是有手势触发调用的, 所以需要判断
    if ([gesture isKindOfClass:UIGestureRecognizer.class]) {
        // 收集到的数据-- 逻辑上, 所有数据围绕 gesture.view(UIView)
        NSString *elementPath = [gesture.view elementPathWithIndexPath:nil];
        NSString *actionName = gesture.methodName;
        NSString *targetName = gesture.targetName;
        NSString *className = NSStringFromClass(gesture.view.class);
        NSString *date = [NSString stringWithFormat:@"%f",[NSDate date].timeIntervalSince1970];
        NSString *analysisName = @"";
        if ([gesture.view isKindOfClass:UILabel.class]) {
            analysisName = [(UILabel *)gesture.view text];
        }
        
        if (!elementPath) {
            return;
        }
        
        // 滑动返回手势不统计
        if ([className isEqualToString:@"UILayoutContainerView"]) {
            return;
        }
        
        // 保存数据
        [[DataCacheManager shareManager] saveEventDataWithSessionId:[ZYGlobalInfoHelper sessionId] targetName:targetName actionName:actionName className:className elementPath:elementPath analysisName:analysisName date:date indexPath:nil selected:false tag:gesture.view.tag];
    }
    
    // 最后调用原方法
    // 在添加手势时, 动态给target 添加了一个名为 "target+action", 而后和 名为gesture.methondName 的方法交换实现
    // 所以调用原方法调用的是 sel_name 而不是 gesture.methodName
    NSString *sel_name = [NSString stringWithFormat:@"%@%@",NSStringFromClass(self.class),NSStringFromSelector(_cmd)];
    SEL sel = NSSelectorFromString(sel_name);
    if ([self respondsToSelector:sel]) {
        IMP imp = [self methodForSelector:sel];
        void (*func)(id, SEL,id) = (void *)imp;
        func(self, sel,gesture);
    }
}

- (NSString *)tempSelName {
    return [NSString stringWithFormat:@"%@%@", self.targetName,self.methodName];
}
@end
