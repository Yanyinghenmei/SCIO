//
//  UIViewController+ZYAnalysis.m
//  ZYDataCollectionDemo
//
//  Created by Daniel Chuang on 2019/3/6.
//  Copyright © 2019年 Daniel Chuang. All rights reserved.
//

#import "UIViewController+ZYAnalysis.h"
#import "MethodSwizzingTool.h"
#import "DataContainer.h"
#import <objc/runtime.h>
#import "UIView+ZYNode.h"
#import "ZYHeader.h"

@implementation UIViewController (ZYAnalysis)
+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL originalViewWillAppearSelector = @selector(viewWillAppear:);
        SEL swizzingViewWillAppearSelector = @selector(zy_viewWillAppear:);
        
        [MethodSwizzingTool swizzingForClass:[self class] originalSel:originalViewWillAppearSelector swizzingSel:swizzingViewWillAppearSelector];
        
        SEL originalViewWillDisappearSelector = @selector(viewWillDisappear:);
        SEL swizzingViewWillDisappearSelector = @selector(zy_viewWillDisappear:);
        
        [MethodSwizzingTool swizzingForClass:[self class] originalSel:originalViewWillDisappearSelector swizzingSel:swizzingViewWillDisappearSelector];
    });
}

- (void)zy_viewWillAppear:(BOOL)animated {
    [self zy_viewWillAppear:animated];
    
    // 收集数据--  逻辑上, 所有数据围绕 tableView
    SEL or_sel = @selector(viewWillAppear:);
    NSString *elementPath = [self.view elementPathWithIndexPath:nil];
    NSString *actionName = NSStringFromSelector(or_sel);
    NSString *className = NSStringFromClass(self.class);
    NSString *targetName = className;
    NSString *date = [NSString stringWithFormat:@"%f",[NSDate date].timeIntervalSince1970];
    NSString *analysisName = self.title;
    if (!analysisName) {
        analysisName = NSStringFromClass(self.class);
    }

    // 保存数据
    [[DataCacheManager shareManager] savePageVisitDataWithSessionId:[[ZYGlobalInfoHelper shareHelper] sessionId] targetName:targetName actionName:actionName className:className elementPath:elementPath analysisName:analysisName date:date tag:self.view.tag];
}
- (void)zy_viewWillDisappear:(BOOL)animated {
    [self zy_viewWillDisappear:animated];
    
    SEL or_sel = @selector(viewWillDisappear:);
    NSString *elementPath = [self.view elementPathWithIndexPath:nil];
    NSString *actionName = NSStringFromSelector(or_sel);
    NSString *className = NSStringFromClass(self.class);
    NSString *targetName = className;
    NSString *date = [NSString stringWithFormat:@"%f",[NSDate date].timeIntervalSince1970];
    NSString *analysisName = self.title;
    if (!analysisName) {
        analysisName = NSStringFromClass(self.class);
    }
    
    // 保存数据
    [[DataCacheManager shareManager] savePageVisitDataWithSessionId:[[ZYGlobalInfoHelper shareHelper] sessionId] targetName:targetName actionName:actionName className:className elementPath:elementPath analysisName:analysisName date:date tag:self.view.tag];
}

@end
